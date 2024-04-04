# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json
        before_action :drop_session_cookie
        skip_before_action :verify_authenticity_token

        private

        def respond_with(user, _opts = {})
          if request.method == 'POST' && user.persisted?
            user_json = JSON.parse(ApplicationController.render(
                                     template: 'api/v1/current_user/show',
                                     assigns: { user: }
                                   ))

            render json: {
              message: 'Signed up successfully.',
              data: { user: user_json }
            }, status: :ok
          elsif request.method == 'DELETE'
            render json: { message: 'Account deleted successfully.' }, status: :ok
          else
            render json: { message: "Couldn't create user. #{resource.errors.full_messages.to_sentence}." },
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
