# frozen_string_literal: true

module Api
  module V1
    class ProductsController < ApiController
      before_action :set_product, only: %i[show update destroy delete_image_attachment]
      before_action :set_view_path, only: %i[create update]

      # GET /api/v1/products
      def index
        @products = current_user.products
      end

      # GET /api/v1/products/1
      def show; end

      # POST /api/v1/products
      def create
        @product = Product.new(product_params)
        @product.user_id = current_user.id

        if @product.save
          render 'show', status: :created
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/products/1
      def update
        if @product.update(product_params)
          render 'show', status: :ok
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/products/1
      def destroy
        @product.destroy!

        head :no_content
      end

      # DELETE /api/v1/products/1/image
      def delete_image_attachment
        @image = ActiveStorage::Blob.find_signed(params[:signed_id])
        return render json: { errors: 'Image not found.' }, status: :not_found if @image.nil?

        @image.attachments.first.purge
        render status: :no_content
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_product
        @product = current_user.products.find_by_id(params[:id])
        render json: { errors: 'Product not found.' }, status: :not_found if @product.nil?
      end

      # Only allow a list of trusted parameters through.
      def product_params
        params.require(:product).permit(:name, :barcode, :image)
      end

      def set_view_path
        prepend_view_path 'app/views/api/v1/products'
      end
    end
  end
end
