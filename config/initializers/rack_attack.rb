class Rack::Attack
  # --- Configure Cache Store (Redis) ---
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(
    url: ENV['REDIS_URL']
  )

  # =========================================================
  # THROTTLES
  # =========================================================

  # --- General API: 300 req/5min per IP ---
  throttle('api/ip', limit: 300, period: 5.minutes) do |req|
    req.ip if req.path.start_with?('/api/')
  end

  # --- Login: 5 attempts/5min per IP ---
  throttle('login/ip', limit: 5, period: 5.minutes) do |req|
    if req.path == '/api/v1/auth/login' && req.post?
      req.ip
    end
  end

  # --- Login: 5 attempts/5min per email (account-level protection) ---
  throttle('login/email', limit: 5, period: 5.minutes) do |req|
    if req.path == '/api/v1/auth/login' && req.post?
      body = JSON.parse(req.body.read) rescue {}
      req.body.rewind
      email = body.dig('user', 'email')
      email&.downcase&.strip
    end
  end

  # --- Registration: 3 accounts/hour per IP ---
  throttle('register/ip', limit: 3, period: 1.hour) do |req|
    req.ip if req.path == '/api/v1/auth/register' && req.post?
  end

  # --- Password Reset: 5 requests/hour per IP ---
  throttle('password_reset/ip', limit: 5, period: 1.hour) do |req|
    req.ip if req.path == '/api/v1/auth/password' && req.post?
  end

  # =========================================================
  # BLOCKLISTS
  # =========================================================

  # Block IPs that repeatedly trigger auth throttles.
  blocklist('block-malicious-ip') do |req|
    Rack::Attack::Allow2Ban.filter(req.ip, maxretry: 20, findtime: 1.hour, bantime: 24.hours) do
      req.path.start_with?('/api/v1/auth/') &&
        req.env['rack.attack.match_type'] == :throttle
    end
  end

  # =========================================================
  # CUSTOM RESPONSE
  # =========================================================

  self.throttled_responder = lambda do |env|
    match_data = env['rack.attack.match_data'] || {}
    now = match_data[:epoch_time] || Time.now.to_i
    period = match_data[:period] || 60
    limit = match_data[:limit] || 0

    retry_after = period - (now % period)

    headers = {
      'Content-Type' => 'application/json',
      'X-RateLimit-Limit' => limit.to_s,
      'X-RateLimit-Remaining' => '0',
      'X-RateLimit-Reset' => (now + retry_after).to_s,
      'Retry-After' => retry_after.to_s
    }

    body = {
      success: false,
      message: 'Too many requests. Please try again later.',
      errors: [],
      code: 'RATE_LIMITED',
      retry_after_seconds: retry_after
    }.to_json

    [429, headers, [body]]
  end

  # =========================================================
  # LOGGING
  # =========================================================

  ActiveSupport::Notifications.subscribe('rack.attack') do |_name, _start, _finish, _id, payload|
    request = payload[:request]
    throttle = request.env['rack.attack.matched']
    ip = request.ip
    path = request.path

    Rails.logger.warn(
      "[RackAttack] #{throttle} | IP: #{ip} | Path: #{path} | " \
      "Count: #{request.env['rack.attack.match_data']&.dig(:count)}"
    )
  end
end
