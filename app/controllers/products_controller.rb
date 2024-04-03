# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy delete_image_attachment]

  # GET /products
  def index
    @products = current_user.products
  end

  # GET /products/1
  def show; end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit; end

  # POST /products
  def create
    @product = Product.new(product_params)
    @product.user_id = current_user.id

    if @product.save
      redirect_to product_url(@product), notice: 'Product was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      redirect_to product_url(@product), notice: 'Product was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy!

    redirect_to products_url, notice: 'Product was successfully destroyed.'
  end

  def delete_image_attachment
    @image = ActiveStorage::Blob.find_signed(params[:signed_id])
    @image.attachments.first.purge

    redirect_to product_url(@product), notice: 'Image from the product was successfully removed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = current_user.products.find_by_hashid(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:name, :barcode, :image)
  end
end
