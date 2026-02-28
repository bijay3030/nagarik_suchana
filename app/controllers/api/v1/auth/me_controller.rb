module Api
  module V1
    module Auth
      class MeController < Api::V1::BaseController
        def show
          render json: {
            success: true,
            message: "Session valid.",
            data: {
              user: {
                id: current_user.id,
                email: current_user.email,
                first_name: current_user.first_name,
                last_name: current_user.last_name,
                full_name: current_user.full_name,
                role: current_user.role,
                initials: current_user.initials,
                created_at: current_user.created_at
              }
            }
          }, status: :ok
        end
      end
    end
  end
end
