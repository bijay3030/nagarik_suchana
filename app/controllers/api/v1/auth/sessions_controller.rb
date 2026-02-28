module Api
  module V1
    module Auth
      class SessionsController < Devise::SessionsController
        include ApiRespondable
        include ExceptionHandler

        respond_to :json

        private

        def respond_with(resource, _opts = {})
          render_success(
            data: UserSerializer.new(resource).serializable_hash,
            message: "Logged in successfully.",
            status: :ok
          )
        end

        def respond_to_on_destroy(_resource = nil)
          if request.headers["Authorization"].blank?
            render_unauthorized(message: "Authorization header is missing.")
          else
            render_success(message: "Logged out successfully.", status: :ok)
          end
        end
      end
    end
  end
end
