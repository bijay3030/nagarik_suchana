require "rails_helper"

RSpec.describe "Admin::GovernmentNotices", type: :request do
  describe "authorization" do
    it "returns 403 for non-admin create" do
      user = create(:user, role: :user)
      token, = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)

      post "/api/v1/admin/government_notices",
           params: { government_notice: { title: "X", description: "Y" * 20, category: "General", effective_date: Date.current, status: "draft" } },
           headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:forbidden)
    end
  end
end
