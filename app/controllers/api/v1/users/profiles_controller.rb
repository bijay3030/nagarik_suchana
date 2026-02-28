module Api
  module V1
    module Users
      class ProfilesController < Api::V1::BaseController
        def show
          render_success(
            data: UserSerializer.new(current_user).serializable_hash,
            message: "Profile fetched successfully."
          )
        end

        def update
          if current_user.update(profile_params)
            render_success(
              data: UserSerializer.new(current_user).serializable_hash,
              message: "Profile updated successfully."
            )
          else
            render_error(
              message: "Profile update failed.",
              errors: current_user.errors.full_messages,
              status: :unprocessable_entity,
              code: Errors::ErrorCodes::VALIDATION_ERROR
            )
          end
        end

        private

        def profile_params
          params.require(:user).permit(:first_name, :last_name, :email)
        end
      end
    end
  end
end
