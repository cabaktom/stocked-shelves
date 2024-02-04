# frozen_string_literal: true

# Source: https://github.com/heartcombo/devise/blob/main/app/controllers/devise/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  # POST /users
  def create
    super
    if @user.persisted?
      UserMailer.welcome_email(@user).deliver_later
    end
  end
end
