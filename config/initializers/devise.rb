Devise.setup do |config|
  config.mailer_sender = "please-change-me-at-config-initializers-devise@example.com"
  require "devise/orm/active_record"

  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]

  config.skip_session_storage = [:http_auth, :params_auth]
  config.navigational_formats = []
  config.sign_out_via = :delete

  config.jwt do |jwt|
    jwt.secret = ENV["DEVISE_JWT_SECRET_KEY"] || Rails.application.credentials.devise_jwt_secret_key

    jwt.dispatch_requests = [
      ["POST", %r{^/api/v1/auth/login$}]
    ]

    jwt.revocation_requests = [
      ["DELETE", %r{^/api/v1/auth/logout$}]
    ]

    jwt.expiration_time = ENV.fetch("JWT_EXPIRATION_HOURS", 24).to_i.hours.to_i
  end
end
