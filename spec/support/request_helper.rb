module RequestHelper
  def auth_headers(user)
    post "/api/v1/auth/login", params: {
      user: { email: user.email, password: user.password }
    }, as: :json

    token = response.headers["Authorization"]
    { "Authorization" => token, "Content-Type" => "application/json" }
  end
end
