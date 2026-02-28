module Api
  module V1
    module Admin
      class GovernmentNoticesController < Api::V1::BaseController
        before_action :require_admin!
        before_action :set_notice, only: %i[show update destroy publish unpublish archive]

        def index
          scope = GovernmentNotice.unscoped.where(deleted_at: nil)
          scope = scope.where(status: params[:status]) if params[:status].present? && GovernmentNotice.statuses.key?(params[:status])
          scope = scope.by_category(params[:category]) if params[:category].present?
          scope = scope.where("title ILIKE ?", "%#{params[:q]}%") if params[:q].present?
          scope = scope.recent

          notices, meta = paginate(scope)

          render_success(
            data: GovernmentNoticeSerializer.collection(notices, include_admin_fields: true),
            message: "Government notices fetched successfully.",
            meta: meta
          )
        end

        def show
          render_success(
            data: GovernmentNoticeSerializer.admin(@notice),
            message: "Government notice fetched successfully."
          )
        end

        def create
          result = GovernmentNotices::CreateNoticeService.call(params: notice_params.to_h.symbolize_keys, current_user: current_user)
          return render_validation_error_from_messages(result[:errors]) unless result[:success]

          render_created(data: GovernmentNoticeSerializer.admin(result[:notice]), message: "Government notice created successfully.")
        end

        def update
          result = GovernmentNotices::UpdateNoticeService.call(notice: @notice, params: notice_params.to_h.symbolize_keys, current_user: current_user)
          return render_validation_error_from_messages(result[:errors]) unless result[:success]

          render_success(data: GovernmentNoticeSerializer.admin(result[:notice]), message: "Government notice updated successfully.")
        end

        def destroy
          return render_error(message: "Notice is already deleted.", status: :unprocessable_entity, code: Errors::ErrorCodes::VALIDATION_ERROR) if @notice.deleted_at.present?

          @notice.soft_delete!
          render_success(message: "Government notice deleted successfully.")
        end

        def publish
          result = GovernmentNotices::PublishNoticeService.call(notice: @notice, current_user: current_user)
          return render_validation_error_from_messages(result[:errors]) unless result[:success]

          render_success(data: GovernmentNoticeSerializer.admin(result[:notice]), message: "Government notice published successfully.")
        end

        def unpublish
          @notice.update!(status: :draft, published_at: nil, updater: current_user)
          render_success(data: GovernmentNoticeSerializer.admin(@notice), message: "Government notice unpublished successfully.")
        end

        def archive
          result = GovernmentNotices::ArchiveNoticeService.call(notice: @notice, current_user: current_user)
          return render_validation_error_from_messages(result[:errors]) unless result[:success]

          render_success(data: GovernmentNoticeSerializer.admin(result[:notice]), message: "Government notice archived successfully.")
        end

        private

        def set_notice
          @notice = GovernmentNotice.unscoped.find(params[:id])
        end

        def notice_params
          params.require(:government_notice).permit(
            :title,
            :description,
            :category,
            :effective_date,
            :status,
            documents: [],
            remove_document_ids: []
          )
        end

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
end
