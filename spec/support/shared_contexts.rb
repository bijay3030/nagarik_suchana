RSpec.shared_context "authenticated user" do
  let(:user) { create(:user) }
  let(:headers) { auth_headers(user) }
end

RSpec.shared_context "authenticated admin" do
  let(:admin) { create(:user, :admin) }
  let(:headers) { auth_headers(admin) }
end

RSpec.shared_context "authenticated business" do
  let(:business_user) { create(:user, :business) }
  let(:headers) { auth_headers(business_user) }
end
