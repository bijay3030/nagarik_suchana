class GovernmentNoticeSerializer
  def self.admin(notice)
    new(notice, include_admin_fields: true).serializable_hash
  end

  def self.public(notice)
    new(notice, include_admin_fields: false).serializable_hash
  end

  def self.collection(collection, include_admin_fields: false)
    collection.map { |notice| new(notice, include_admin_fields: include_admin_fields).serializable_hash }
  end

  def initialize(notice, include_admin_fields: false)
    @notice = notice
    @include_admin_fields = include_admin_fields
  end

  def serializable_hash
    payload = {
      id: @notice.id,
      title: @notice.title,
      description: @notice.description,
      category: @notice.category,
      effective_date: @notice.effective_date,
      status: @notice.status,
      published_at: @notice.published_at,
      created_at: @notice.created_at,
      updated_at: @notice.updated_at,
      creator: creator_payload,
      documents: documents_payload
    }

    if @include_admin_fields
      payload[:deleted_at] = @notice.deleted_at
      payload[:created_by] = @notice.creator_id
      payload[:updated_by] = @notice.updater_id
    end

    payload
  end

  private

  def creator_payload
    return nil unless @notice.creator

    {
      name: @notice.creator.full_name,
      email: @notice.creator.email
    }
  end

  def documents_payload
    @notice.documents.map do |attachment|
      {
        id: attachment.id,
        filename: attachment.blob.filename.to_s,
        content_type: attachment.blob.content_type,
        byte_size: attachment.blob.byte_size,
        url: signed_url_for(attachment)
      }
    end
  end

  def signed_url_for(attachment)
    Rails.application.routes.url_helpers.rails_service_blob_path(
      attachment.blob.signed_id(expires_in: 1.hour),
      attachment.blob.filename,
      disposition: "attachment",
      only_path: true
    )
  rescue StandardError
    Rails.application.routes.url_helpers.rails_blob_path(attachment, disposition: "attachment", only_path: true)
  end
end
