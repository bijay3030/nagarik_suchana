module Api
  module V1
    module Admin
      class DashboardsController < Api::V1::BaseController
        before_action :require_admin!

        def show
          users = User.recent
          render_success(
            data: UserSerializer.new(users).serializable_hash,
            message: "Admin dashboard data fetched successfully."
          )
        end
      end
    end
  end
end
