class ApplicationController < ActionController::API
  def frontend
    render file: Rails.root.join("public/vite/index.html"), layout: false
  end
end
