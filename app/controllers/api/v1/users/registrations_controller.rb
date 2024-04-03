# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json
        before_action :drop_session_cookie
        skip_before_action :verify_authenticity_token

        def respond_with(current_user, _opts = {})
          if request.method == 'POST' && current_user.persisted?
            render json: {
              status: { code: :ok, message: 'Signed up successfully.' },
              data: { user: current_user.id }
            }, status: :ok
          elsif request.method == 'DELETE'
            render json: {
              status: { code: :ok, message: 'Account deleted successfully.' }
            }, status: :ok
          else
            render json: {
                     status: { code: :unprocessable_entity,
                               message: "Couldn't create user. #{resource.errors.full_messages.to_sentence}" }
                   },
                   status: :unprocessable_entity
          end
        end

        protected

        def drop_session_cookie
          request.session_options[:skip] = true
        end
      end
    end
  end
end
