# frozen_string_literal: true

require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActionDispatch::TestProcess::FixtureFile

  setup do
    @user = users(:one)
    @product = products(:one)
    @image_dir = 'files/apple.jpg'
    sign_in @user
  end

  test 'should get index' do
    get products_url
    assert_response :success
    assert_template :index
  end

  test 'should get new' do
    get new_product_url
    assert_response :success
    assert_template :new
  end

  test 'should create product' do
    assert_difference('Product.count') do
      post products_url, params: { product: { name: 'New Product', barcode: 'UniqueBarcode123', user_id: @user.id } }
    end

    assert_redirected_to product_url(Product.last)
  end

  test 'should show product' do
    get product_url(@product)
    assert_response :success
    assert_template :show
  end

  test 'should get edit' do
    get edit_product_url(@product)
    assert_response :success
    assert_template :edit
  end

  test 'should update product' do
    patch product_url(@product), params: { product: { name: 'Updated Product', barcode: @product.barcode } }
    assert_redirected_to product_url(@product)
  end

  test 'should destroy product' do
    assert_difference('Product.count', -1) do
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end

  test 'should attach an image to product' do
    file = fixture_file_upload("test/fixtures/#{@image_dir}", 'image/jpg')
    patch product_url(@product), params: { product: { image: file } }

    @product.reload
    assert @product.image.attached?
  end

  test 'should delete image attachment from product' do
    @product.image.attach(io: File.open("#{fixture_paths.first}#{@image_dir}"), filename: 'apple.jpg',
                          content_type: 'image/jpg')
    signed_id = @product.image.blob.signed_id

    assert_difference('@product.image.attachments.count', -1) do
      delete delete_image_attachment_product_url(@product), params: { signed_id: }
    end

    assert_redirected_to product_url(@product)
  end
end
