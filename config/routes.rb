Rails.application.routes.draw do
  resources :lists
  resources :colors
  devise_for :users

  # Root route
  root "pages#root", as: :root

  # Other routes
  get "dashboard" => "pages#dashboard", as: :dashboard
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
