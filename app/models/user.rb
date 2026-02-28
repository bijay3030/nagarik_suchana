class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: self

  enum :role, { user: 0, business: 1, admin: 2 }

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true, inclusion: { in: roles.keys }
  validates :password,
            length: { minimum: 8 },
            format: {
              with: /\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).+\z/,
              message: "must include uppercase, lowercase, number, and special character"
            },
            if: :password_required?

  after_initialize :set_default_role, if: :new_record?

  scope :admins, -> { where(role: :admin) }
  scope :businesses, -> { where(role: :business) }
  scope :regular_users, -> { where(role: :user) }
  scope :active, -> { where(deleted_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def initials
    return "" if first_name.blank? || last_name.blank?

    "#{first_name[0]}#{last_name[0]}".upcase
  end

  def active_for_authentication?
    super && deleted_at.nil?
  end

  def inactive_message
    return :inactive if deleted_at.present?

    super
  end

  private

  def set_default_role
    self.role ||= :user
  end
end
