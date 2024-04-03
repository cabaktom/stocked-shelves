# frozen_string_literal: true

module Api
  module V1
    class ApiController < ActionController::API
      include ActionController::MimeResponds

      before_action :authenticate_user!
      before_action :configure_permitted_parameters, if: :devise_controller?
      before_action :drop_session_cookie

      protected

      def configure_permitted_parameters
        added_attrs = %i[username email password password_confirmation remember_me notify_through_email]
        devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
        devise_parameter_sanitizer.permit :sign_in, keys: %i[login password]
        devise_parameter_sanitizer.permit :account_update, keys: added_attrs
      end

      private

      def drop_session_cookie
        request.session_options[:skip] = true
      end
    end
  end
end
