class ApplicationController < ActionController::API
  include ApiRespondable
  include ExceptionHandler

  def frontend
    render file: Rails.root.join("public/vite/index.html"), layout: false
  end
end
