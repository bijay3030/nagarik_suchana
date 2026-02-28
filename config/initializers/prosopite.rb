if Rails.env.development?
  begin
    require "prosopite"
  rescue LoadError
    Rails.logger.warn("Prosopite not installed; skipping Prosopite initializer")
    return
  end

  Rails.application.config.after_initialize do
    Prosopite.rails_logger = true
    Prosopite.raise_on_n_plus_one = false
  end
end
