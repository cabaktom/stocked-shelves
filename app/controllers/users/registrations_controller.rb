# frozen_string_literal: true

# Source: https://github.com/heartcombo/devise/blob/main/app/controllers/devise/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  # POST /users
  def create
    super
    return unless @user.persisted?

    UserMailer.welcome_email(@user).deliver_later
  end

  protected

  def after_update_path_for(_resource)
    edit_user_registration_path
  end
end
