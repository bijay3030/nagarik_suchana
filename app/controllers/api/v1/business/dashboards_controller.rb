module Api
  module V1
    module Business
      class DashboardsController < Api::V1::BaseController
        before_action :require_business!

        def show
          render_success(
            data: {
              user: UserSerializer.new(current_user).serializable_hash,
              summary: {
                message: "Business dashboard data fetched successfully."
              }
            },
            message: "Business dashboard fetched successfully."
          )
        end
      end
    end
  end
end
