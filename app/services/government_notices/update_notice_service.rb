module GovernmentNotices
  class UpdateNoticeService < ApplicationService
    def initialize(notice:, params:, current_user:)
      @notice = notice
      @params = params
      @current_user = current_user
    end

    def call
      @notice.assign_attributes(notice_params)
      @notice.updater = @current_user

      remove_documents
      add_documents

      if @notice.save
        { success: true, notice: @notice, errors: [] }
      else
        { success: false, notice: @notice, errors: @notice.errors.full_messages }
      end
    end

    private

    def notice_params
      @params.except(:documents, :remove_document_ids)
    end

    def remove_documents
      return if @params[:remove_document_ids].blank?

      Array(@params[:remove_document_ids]).each do |attachment_id|
        attachment = @notice.documents.find_by(id: attachment_id)
        attachment&.purge_later
      end
    end

    def add_documents
      return if @params[:documents].blank?

      Array(@params[:documents]).each { |file| @notice.documents.attach(file) }
    end
  end
end
