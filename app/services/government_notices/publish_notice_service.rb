module GovernmentNotices
  class PublishNoticeService < ApplicationService
    def initialize(notice:, current_user:)
      @notice = notice
      @current_user = current_user
    end

    def call
      return failure("Archived notice cannot be published directly.") if @notice.archived?
      return failure("Notice is missing required publish fields.") unless @notice.publishable?

      @notice.updater = @current_user
      @notice.status = :published
      @notice.published_at ||= Time.current

      return success if @notice.save

      failure(@notice.errors.full_messages)
    end

    private

    def success
      { success: true, notice: @notice, errors: [] }
    end

    def failure(errors)
      { success: false, notice: @notice, errors: Array(errors) }
    end
  end
end
