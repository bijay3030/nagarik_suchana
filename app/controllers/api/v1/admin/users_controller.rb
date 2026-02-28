module Api
  module V1
    module Admin
      class UsersController < Api::V1::BaseController
        before_action :require_admin!
        before_action :set_user, only: %i[show update destroy]

        def index
          users = User.recent
          render_success(data: UserSerializer.new(users).serializable_hash, message: "Users fetched successfully.")
        end

        def show
          render_success(data: UserSerializer.new(@user).serializable_hash, message: "User fetched successfully.")
        end

        def update
          if @user.update(admin_user_params)
            render_success(data: UserSerializer.new(@user).serializable_hash, message: "User updated successfully.")
          else
            render_error(
              message: "User update failed.",
              errors: @user.errors.full_messages,
              status: :unprocessable_entity,
              code: Errors::ErrorCodes::VALIDATION_ERROR
            )
          end
        end

        def destroy
          @user.update!(deleted_at: Time.current, jti: SecureRandom.uuid)
          render_success(message: "User archived successfully.")
        end

        private

        def set_user
          @user = User.find(params[:id])
        end

        def admin_user_params
          params.require(:user).permit(:first_name, :last_name, :email, :role)
        end
      end
    end
  end
end
