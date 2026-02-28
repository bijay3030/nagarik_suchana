class GovernmentNotice < ApplicationRecord
  CATEGORIES = ["General", "Tax", "Legal", "Environmental", "Health", "Infrastructure"].freeze
  ALLOWED_DOCUMENT_TYPES = [
    "application/pdf",
    "application/msword",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "image/png",
    "image/jpeg"
  ].freeze
  MAX_DOCUMENT_SIZE = 10.megabytes

  enum :status, { draft: 0, published: 1, archived: 2 }

  belongs_to :creator, class_name: "User", foreign_key: :creator_id
  belongs_to :updater, class_name: "User", foreign_key: :updater_id, optional: true

  has_many_attached :documents

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :effective_date, presence: true
  validates :status, presence: true

  validate :validate_documents

  default_scope { where(deleted_at: nil) }

  scope :active, -> { where(deleted_at: nil) }
  scope :published_scope, -> { where(status: :published).where.not(published_at: nil).order(published_at: :desc) }
  scope :by_category, ->(value) { value.present? ? where(category: value) : all }
  scope :recent, -> { order(created_at: :desc) }

  before_save :set_published_at_if_publishing

  def soft_delete!
    update!(deleted_at: Time.current)
  end

  def publishable?
    title.present? && description.present? && effective_date.present?
  end

  private

  def set_published_at_if_publishing
    return unless status_changed?
    return unless published?

    self.published_at ||= Time.current
  end

  def validate_documents
    documents.each do |document|
      if document.blob.byte_size > MAX_DOCUMENT_SIZE
        errors.add(:documents, "#{document.blob.filename} exceeds 10MB")
      end

      unless ALLOWED_DOCUMENT_TYPES.include?(document.blob.content_type)
        errors.add(:documents, "#{document.blob.filename} has unsupported file type")
      end
    end
  end
end
