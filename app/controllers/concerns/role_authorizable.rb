module RoleAuthorizable
  extend ActiveSupport::Concern

  private

  def require_admin!
    return if current_user&.admin?

    render_forbidden(message: "Admin access is required.")
  end

  def require_business!
    return if current_user&.business? || current_user&.admin?

    render_forbidden(message: "Business access is required.")
  end

  def require_user!
    return if current_user.present?

    render_unauthorized(message: "You must be logged in to access this resource.")
  end
end
