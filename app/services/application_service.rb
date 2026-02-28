# Base class for application services.
#
# Contract:
# - Inherit from ApplicationService.
# - Implement an instance #call method.
# - Return an explicit result object (success/failure hash or struct).
# - Do not access HTTP request/response or render JSON from services.
class ApplicationService
  def self.call(*args, **kwargs, &block)
    new(*args, **kwargs, &block).call
  end
end
