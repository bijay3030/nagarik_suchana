module GovernmentNotices
  class CreateNoticeService < ApplicationService
    def initialize(params:, current_user:)
      @params = params
      @current_user = current_user
    end

    def call
      notice = GovernmentNotice.new(notice_params)
      notice.creator = @current_user
      notice.updater = @current_user

      attach_documents(notice)

      if notice.save
        { success: true, notice: notice, errors: [] }
      else
        { success: false, notice: notice, errors: notice.errors.full_messages }
      end
    end

    private

    def notice_params
      @params.except(:documents, :remove_document_ids)
    end

    def attach_documents(notice)
      return if @params[:documents].blank?

      Array(@params[:documents]).each { |file| notice.documents.attach(file) }
    end
  end
end
