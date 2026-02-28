module ApiRespondable
  extend ActiveSupport::Concern

  # --- Success Responses ---

  def render_success(data: {}, message: 'Success', status: :ok, meta: {})
    render json: {
      success: true,
      message: message,
      data: data,
      meta: meta
    }, status: status
  end

  def render_created(data: {}, message: 'Created successfully.')
    render_success(data: data, message: message, status: :created)
  end

  def render_no_content
    head :no_content
  end

  # --- Error Responses ---

  def render_error(message: 'An error occurred.', errors: [], status: :unprocessable_entity, code: Errors::ErrorCodes::INTERNAL_ERROR)
    render json: {
      success: false,
      message: message,
      errors: Array(errors),
      code: code
    }, status: status
  end

  def render_unauthorized(message: 'You must be logged in.')
    render_error(
      message: message,
      status: :unauthorized,
      code: Errors::ErrorCodes::UNAUTHORIZED
    )
  end

  def render_forbidden(message: 'You do not have permission.')
    render_error(
      message: message,
      status: :forbidden,
      code: Errors::ErrorCodes::FORBIDDEN
    )
  end

  def render_not_found(resource = 'Resource')
    render_error(
      message: "#{resource} not found.",
      status: :not_found,
      code: Errors::ErrorCodes::NOT_FOUND
    )
  end

  def render_validation_error(record)
    render_error(
      message: 'Validation failed.',
      errors: record.errors.full_messages,
      status: :unprocessable_entity,
      code: Errors::ErrorCodes::VALIDATION_ERROR
    )
  end

  def render_validation_error_from_messages(messages)
    render_error(
      message: 'Validation failed.',
      errors: messages,
      status: :unprocessable_entity,
      code: Errors::ErrorCodes::VALIDATION_ERROR
    )
  end

  # --- Paginated Response ---

  def render_paginated(data:, collection:, message: 'Success')
    render json: {
      success: true,
      message: message,
      data: data,
      meta: {
        current_page: collection.current_page,
        total_pages: collection.total_pages,
        total_count: collection.total_count,
        per_page: collection.limit_value
      }
    }, status: :ok
  end
end
