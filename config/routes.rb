Rails.application.routes.draw do
  # ==========================
  #      HTML WEB ROUTES
  # ==========================
  root "jogging_entries#index"

  resources :users
  resources :jogging_entries do
    get :weekly_report, on: :collection
  end

  # HTML login/logout
  get    "/login",  to: "sessions#new"
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # ==========================
  #          API ROUTES
  # ==========================
  namespace :api, defaults: { format: :json } do
    # API sessions
    post   "login",  to: "sessions#create"
    delete "logout", to: "sessions#destroy"

    # API resources
    resources :users
    resources :jogging_entries do
      get :weekly_report, on: :collection
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
