module Api
  module V1
    class GovernmentNoticesController < Api::V1::BaseController
      def index
        scope = GovernmentNotice.published_scope.active
        scope = scope.by_category(params[:category]) if params[:category].present?
        scope = if params[:sort] == "effective_date_asc"
                  scope.order(effective_date: :asc)
                else
                  scope.order(effective_date: :desc)
                end

        notices, meta = paginate(scope)

        render_success(
          data: GovernmentNoticeSerializer.collection(notices),
          message: "Government notices fetched successfully.",
          meta: meta
        )
      end

      def show
        notice = GovernmentNotice.published_scope.find(params[:id])
        render_success(
          data: GovernmentNoticeSerializer.public(notice),
          message: "Government notice fetched successfully."
        )
      end

      private

      def paginate(scope)
        page = params.fetch(:page, 1).to_i
        per_page = params.fetch(:per_page, 25).to_i.clamp(1, 100)

        total_count = scope.count
        total_pages = (total_count.to_f / per_page).ceil
        records = scope.offset((page - 1) * per_page).limit(per_page)

        meta = {
          current_page: page,
          total_pages: total_pages,
          total_count: total_count,
          per_page: per_page
        }

        [records, meta]
      end
    end
  end
end
