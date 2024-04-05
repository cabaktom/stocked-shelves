# frozen_string_literal: true

module Api
  module V1
    class ListsController < ApiController
      before_action :set_list, only: %i[show update destroy]

      # GET /api/v1/lists
      def index
        @lists = current_user.lists
      end

      # GET /api/v1/lists/1
      def show; end

      # POST /api/v1/lists
      def create
        @list = List.new(list_params)
        @list.user_id = current_user.id

        if @list.save
          render :show, status: :created
        else
          render json: { error: @list.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/lists/1
      def update
        if @list.update(list_params)
          render :show, status: :ok
        else
          render json: { error: @list.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/lists/1
      def destroy
        @list.destroy!
        head :no_content
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_list
        @list = current_user.lists.find_by_id(params[:id])
        render json: { error: 'List not found.' }, status: :not_found if @list.nil?
      end

      # Only allow a list of trusted parameters through.
      def list_params
        params.require(:list).permit(:name, :color_id)
      end
    end
  end
end
