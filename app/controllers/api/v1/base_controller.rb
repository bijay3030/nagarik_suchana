module Api
  module V1
    class BaseController < ApplicationController
      include ApiRespondable
      include ExceptionHandler
      include RoleAuthorizable

      before_action :authenticate_user!

      private

      def current_user_response
        data = UserSerializer.new(current_user).serializable_hash
        render_success(data: data, message: "Current user fetched successfully.")
      end
    end
  end
end
