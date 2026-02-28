Rails.application.routes.draw do
  devise_for :users,
             path: "api/v1/auth",
             path_names: {
               sign_in: "login",
               sign_out: "logout",
               registration: "register"
             },
             controllers: {
               sessions: "api/v1/auth/sessions",
               registrations: "api/v1/auth/registrations"
             }

  namespace :api do
    namespace :v1 do
      namespace :users do
        resource :profile, only: %i[show update]
      end

      namespace :business do
        resource :dashboard, only: %i[show]
      end

      namespace :admin do
        resource :dashboard, only: %i[show]
        resources :users, only: %i[index show update destroy]
      end

      get "auth/me", to: "auth/me#show"
      get "health", to: "health#index"
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  get "*path", to: "application#frontend", constraints: lambda { |req|
    !req.xhr? && req.format.html?
  }
end
