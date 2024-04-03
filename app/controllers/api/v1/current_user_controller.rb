# frozen_string_literal: true

module Api
  module V1
    class CurrentUserController < ApiController
      before_action :authenticate_user!

      def show
        render json: current_user.id
      end
    end
  end
end
