Sentry.init do |config|
  config.dsn = ENV["SENTRY_DSN"]

  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  config.before_send = lambda do |event, _hint|
    event.request&.data&.delete("password")
    event.request&.data&.delete("password_confirmation")
    event.request&.data&.delete("token")
    event
  end

  config.enabled_environments = %w[production staging]
  config.traces_sample_rate = 0.2
end
