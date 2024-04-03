# frozen_string_literal: true

module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        respond_to :json
        before_action :drop_session_cookie, only: %i[destroy]
        skip_before_action :verify_authenticity_token

        def respond_with(current_user, _opts = {})
          if current_user
            render json: {
              status: { code: :ok, message: 'Logged in successfully.' },
              data: { user: current_user.id }
            }, status: :ok
          else
            render json: {
              status: { code: :unauthorized, message: 'Invalid Email or Password' }
            }, status: :unauthorized
          end
        end

        def respond_to_on_destroy
          if current_user
            render json: {
              status: 200,
              message: 'Logged out successfully'
            }, status: :ok
          else
            render json: {
              status: 401,
              message: "Couldn't find an active session."
            }, status: :unauthorized
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
