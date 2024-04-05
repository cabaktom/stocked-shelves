# frozen_string_literal: true

module Api
  module V1
    class NotificationsController < ApiController
      before_action :set_notification, only: %i[show update destroy]

      # GET /api/v1/notifications
      def index
        @notifications = current_user.notifications
      end

      # GET /api/v1/notifications/1
      def show; end

      # POST /api/v1/notifications
      def create
        @notification = Notification.new(notification_params)
        @notification.user_id = current_user.id

        if @notification.save
          render :show, status: :created
        else
          render json: { error: @notification.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/notifications/1
      def update
        if @notification.update(notification_params)
          render :show, status: :ok
        else
          render json: { error: @notification.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/notifications/1
      def destroy
        @notification.destroy!
        head :no_content
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_notification
        @notification = current_user.notifications.find_by_id(params[:id])
        render json: { error: 'Notification not found.' }, status: :not_found if @notification.nil?
      end

      # Only allow a list of trusted parameters through.
      def notification_params
        params.require(:notification).permit(:days_before_expiration)
      end
    end
  end
end
