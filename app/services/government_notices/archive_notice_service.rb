module GovernmentNotices
  class ArchiveNoticeService < ApplicationService
    def initialize(notice:, current_user:)
      @notice = notice
      @current_user = current_user
    end

    def call
      @notice.updater = @current_user
      @notice.status = :archived
      @notice.published_at = nil

      if @notice.save
        { success: true, notice: @notice, errors: [] }
      else
        { success: false, notice: @notice, errors: @notice.errors.full_messages }
      end
    end
  end
end
