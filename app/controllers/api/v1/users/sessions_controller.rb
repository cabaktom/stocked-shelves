# frozen_string_literal: true

module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        respond_to :json
        before_action :drop_session_cookie
        skip_before_action :verify_authenticity_token

        private

        def respond_with(user, _opts = {})
          current_user_json = JSON.parse(ApplicationController.render(
                                           template: 'api/v1/current_user/show',
                                           assigns: { user: }
                                         ))

          render json: {
            message: 'Logged in successfully.',
            data: { user: current_user_json }
          }, status: :ok
        end

        def respond_to_on_destroy
          if current_user
            render json: { message: 'Logged out successfully.' }, status: :ok
          else
            render json: { message: "Couldn't find an active session and log out." }, status: :unauthorized
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
