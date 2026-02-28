require "rails_helper"

RSpec.describe "Shared GovernmentNotices", type: :request do
  it "requires auth" do
    get "/api/v1/government_notices"
    expect(response).to have_http_status(:unauthorized)
  end
end
