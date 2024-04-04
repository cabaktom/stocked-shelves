# frozen_string_literal: true

module Api
  module V1
    class CurrentUserController < ApiController
      def show
        @user = current_user
      end
    end
  end
end
