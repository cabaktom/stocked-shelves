# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ApiController
      before_action :set_item, only: %i[show update destroy]

      # GET /api/v1/items
      def index
        @items = current_user.items
      end

      # GET /api/v1/items/1
      def show; end

      # POST /api/v1/items
      def create
        @item = Item.new(item_params)
        @item.user_id = current_user.id

        if @item.save
          render :show, status: :created
        else
          render json: { error: @item.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/items/1
      def update
        if @item.update(item_params)
          render :show, status: :ok
        else
          render json: { error: @item.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/items/1
      def destroy
        @item.destroy!
        head :no_content
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_item
        @item = current_user.items.find_by_id(params[:id])
        render json: { error: 'Item not found.' }, status: :not_found if @item.nil?
      end

      # Only allow a list of trusted parameters through.
      def item_params
        params.require(:item).permit(:quantity, :expiration, :expired, :used, :product_id, :list_id,
                                     notifications_ids: [])
      end

      def schedule_expiration_notification
        return unless current_user.notify_through_email
        return unless @item.expiration
        return if @item.expired? || @item.used?

        @item.notification.each do |notification|
          EmailExpirationNotificationJob.set(wait_until: @item.expiration - notification.days_before_expiration.days)
                                        .perform_later(current_user, @item, @item.expiration, notification)
        end
      end
    end
  end
end
