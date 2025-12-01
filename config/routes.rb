Rails.application.routes.draw do
  root "jogging_entries#index"

  resources :users

  resources :jogging_entries do
    collection do
      get :weekly_report
    end
  end

  get    "/login",  to: "sessions#new"
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "up" => "rails/health#show", as: :rails_health_check
end
