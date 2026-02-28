module Api
  module V1
    module Auth
      class RegistrationsController < Devise::RegistrationsController
        include ApiRespondable
        include ExceptionHandler

        respond_to :json

        private

        def respond_with(resource, _opts = {})
          if resource.persisted?
            render_success(
              data: UserSerializer.new(resource).serializable_hash,
              message: "Registration successful.",
              status: :created
            )
          else
            render_error(
              message: "Registration failed.",
              errors: resource.errors.full_messages,
              status: :unprocessable_entity,
              code: Errors::ErrorCodes::VALIDATION_ERROR
            )
          end
        end

        def sign_up_params
          params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
        end

        # API-only app: avoid writing to cookie session.
        def sign_up(_resource_name, _resource)
        end
      end
    end
  end
end
