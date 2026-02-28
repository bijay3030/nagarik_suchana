module Errors
  class ApplicationError < StandardError
    attr_reader :code, :status, :details

    def initialize(message = "An unexpected error occurred", code: "ERROR", status: 500, details: [])
      @code = code
      @status = status
      @details = details
      super(message)
    end
  end

  class AuthenticationError < ApplicationError
    def initialize(msg = "Authentication failed")
      super(msg, code: "UNAUTHORIZED", status: 401)
    end
  end

  class AuthorizationError < ApplicationError
    def initialize(msg = "Access denied")
      super(msg, code: "FORBIDDEN", status: 403)
    end
  end

  class NotFoundError < ApplicationError
    def initialize(resource = "Resource")
      super("#{resource} not found", code: "NOT_FOUND", status: 404)
    end
  end

  class ValidationError < ApplicationError
    def initialize(errors = [])
      super("Validation failed", code: "VALIDATION_ERROR", status: 422, details: errors)
    end
  end

  class ServiceError < ApplicationError
    def initialize(msg = "Service operation failed")
      super(msg, code: "SERVICE_ERROR", status: 500)
    end
  end

  class RateLimitError < ApplicationError
    def initialize
      super("Too many requests. Try again later.", code: "RATE_LIMITED", status: 429)
    end
  end
end
