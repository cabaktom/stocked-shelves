# frozen_string_literal: true

module Api
  module V1
    class CurrentUserController < ApiController
      before_action :authenticate_user!

      def show
        @user = current_user
      end
    end
  end
end
