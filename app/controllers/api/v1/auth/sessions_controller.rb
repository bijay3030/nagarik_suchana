module Api
  module V1
    module Auth
      class SessionsController < Devise::SessionsController
        respond_to :json

        private

        def respond_with(resource, _opts = {})
          render json: {
            success: true,
            message: "Logged in successfully.",
            data: {
              user: serialize_user(resource),
              token_expires_at: token_expiry
            }
          }, status: :ok
        end

        def respond_to_on_destroy(_resource = nil)
          if request.headers["Authorization"].present?
            render json: {
              success: true,
              message: "Logged out successfully."
            }, status: :ok
          else
            render json: {
              success: false,
              message: "No active session.",
              code: "UNAUTHORIZED"
            }, status: :unauthorized
          end
        end

        def serialize_user(user)
          {
            id: user.id,
            email: user.email,
            first_name: user.first_name,
            last_name: user.last_name,
            full_name: user.full_name,
            role: user.role,
            initials: user.initials,
            created_at: user.created_at
          }
        end

        def token_expiry
          Time.now + ENV.fetch("JWT_EXPIRATION_HOURS", 24).to_i.hours
        end
      end
    end
  end
end
