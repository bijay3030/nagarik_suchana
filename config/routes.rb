Rails.application.routes.draw do
  namespace :api do
    get "health", to: "health#index"
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Catch-all: serve React app for any non-API route in production
  get "*path", to: "application#frontend", constraints: lambda { |req|
    !req.xhr? && req.format.html?
  }
end
