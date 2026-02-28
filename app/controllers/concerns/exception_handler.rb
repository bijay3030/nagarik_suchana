module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    # --- Custom App Errors ---
    rescue_from Errors::ApplicationError do |e|
      log_error(e)
      render_app_error(e)
    end

    # --- ActiveRecord Errors ---
    rescue_from ActiveRecord::RecordNotFound do |e|
      log_error(e)
      render_error(
        message: "Record not found.",
        status: :not_found,
        code: "NOT_FOUND"
      )
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      log_error(e)
      render_error(
        message: "Validation failed.",
        errors: e.record.errors.full_messages,
        status: :unprocessable_entity,
        code: "VALIDATION_ERROR"
      )
    end

    rescue_from ActiveRecord::RecordNotUnique do |e|
      log_error(e)
      render_error(
        message: "A duplicate record already exists.",
        status: :conflict,
        code: "ALREADY_EXISTS"
      )
    end

    # --- JWT Errors ---
    if defined?(JWT::ExpiredSignature)
      rescue_from JWT::ExpiredSignature do |e|
        log_error(e)
        render_error(
          message: "Your session has expired. Please log in again.",
          status: :unauthorized,
          code: "TOKEN_EXPIRED"
        )
      end
    end

    if defined?(JWT::DecodeError)
      rescue_from JWT::DecodeError do |e|
        log_error(e)
        render_error(
          message: "Invalid token.",
          status: :unauthorized,
          code: "TOKEN_INVALID"
        )
      end
    end

    # --- Devise / Warden ---
    if defined?(Warden::NotAuthenticated)
      rescue_from Warden::NotAuthenticated do |e|
        log_error(e)
        render_error(
          message: "You must be logged in to access this resource.",
          status: :unauthorized,
          code: "UNAUTHORIZED"
        )
      end
    end

    # --- Parameter Errors ---
    rescue_from ActionController::ParameterMissing do |e|
      log_error(e)
      render_error(
        message: "Missing required parameter: #{e.param}",
        status: :bad_request,
        code: "MISSING_PARAMETER"
      )
    end

    # --- Catch-All ---
    rescue_from StandardError do |e|
      log_error(e)
      Sentry.capture_exception(e) if defined?(Sentry)

      render_error(
        message: Rails.env.production? ? "An unexpected error occurred." : e.message,
        status: :internal_server_error,
        code: "INTERNAL_ERROR"
      )
    end
  end

  private

  def render_app_error(error)
    render json: {
      success: false,
      message: error.message,
      errors: error.details,
      code: error.code
    }, status: error.status
  end

  def log_error(error)
    Rails.logger.error(
      {
        error: error.class.name,
        message: error.message,
        backtrace: error.backtrace&.first(5),
        user_id: safe_current_user_id,
        request_id: request.request_id,
        path: request.path,
        method: request.method
      }.to_json
    )
  end

  def safe_current_user_id
    return unless respond_to?(:current_user, true)

    current_user&.id
  rescue StandardError
    nil
  end
end
