# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users,
             controllers: { registrations: 'users/registrations' },
             path: '',
             path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', edit: 'profile' }

  resources :lists
  resources :colors
  resources :products do
    delete :delete_image_attachment, on: :member
  end
  resources :items
  resources :notifications

  # Root route
  root 'pages#root', as: :root

  # Other routes
  get 'dashboard' => 'pages#dashboard', as: :dashboard
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
end
