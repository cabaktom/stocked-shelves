# frozen_string_literal: true

module Api
  module V1
    class ColorsController < ApiController
      before_action :set_color, only: %i[show update destroy]

      # GET /api/v1/colors
      def index
        @colors = current_user.colors
      end

      # GET /api/v1/colors/1
      def show; end

      # POST /api/v1/colors
      def create
        @color = Color.new(color_params)
        @color.user_id = current_user.id

        if @color.save
          render :show, status: :created
        else
          render json: { error: @color.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/colors/1
      def update
        if @color.update(color_params)
          render :show, status: :ok
        else
          render json: { error: @color.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/colors/1
      def destroy
        @color.destroy!
        head :no_content
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_color
        @color = current_user.colors.find_by_id(params[:id])
        render json: { error: 'Color not found.' }, status: :not_found if @color.nil?
      end

      # Only allow a list of trusted parameters through.
      def color_params
        params.require(:color).permit(:name, :hex_code)
      end
    end
  end
end
