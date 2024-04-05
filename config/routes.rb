# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  # Browser-based application routes
  mount Sidekiq::Web => '/sidekiq'

  root 'pages#root', as: :root

  # Devise
  devise_for :users,
             controllers: { registrations: 'users/registrations' },
             path: '',
             path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', edit: 'profile' }

  # Resources (CRUD routes)
  resources :lists
  resources :colors
  resources :products do
    delete :delete_image_attachment, on: :member
  end
  resources :items
  resources :notifications

  # Other
  get 'dashboard' => 'pages#dashboard', as: :dashboard
  get 'up' => 'rails/health#show', as: :rails_health_check

  # ================================
  # API routes
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # Devise
      devise_scope :user do
        # Sessions
        post 'login', to: 'users/sessions#create', as: :session_create
        delete 'logout', to: 'users/sessions#destroy', as: :session_destroy

        # Registrations
        post 'register', to: 'users/registrations#create', as: :user_registration_create        # Sign up
        patch 'profile', to: 'users/registrations#update', as: :user_registration_update        # Edit profile
        delete 'profile', to: 'users/registrations#destroy', as: :user_registration_destroy     # Delete profile

        # Passwords
        post 'password', to: 'devise/passwords#create', as: :user_password_create     # Reset password
        put 'password', to: 'devise/passwords#update', as: :user_password_update      # Change password
      end

      devise_for :users,
                 skip: %i[sessions registrations passwords],
                 controllers: { sessions: 'users/sessions', registrations: 'users/registrations' },
                 path: ''

      # Resources (CRUD routes)
      resources :lists, only: %i[index show create update destroy]
      resources :colors, only: %i[index show create update destroy]
      resources :products, only: %i[index show create update destroy] do
        delete 'image', to: 'products#delete_image_attachment', on: :member
      end
      resources :items, only: %i[index show create update destroy]
      resources :notifications, only: %i[index show create update destroy]

      # Other
      get 'current_user', to: 'current_user#show', as: :current_user
    end
  end
end
