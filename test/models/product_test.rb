# frozen_string_literal: true

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @product = Product.new(name: 'Sample Product', user: @user, barcode: '1234567890')
  end

  test 'valid product' do
    assert @product.valid?
  end

  test 'invalid without name' do
    @product.name = nil
    assert_not @product.valid?, 'Product is valid without a name'
    assert_not_nil @product.errors[:name], 'no validation error for name present'
  end

  test 'barcode uniqueness' do
    duplicate_product = @product.dup
    @product.save
    assert_not duplicate_product.valid?, 'Product is valid with a duplicate barcode'
    assert_not_nil duplicate_product.errors[:barcode], 'no validation error for duplicate barcode'
  end

  test 'belongs to user' do
    assert_respond_to @product, :user, 'Product does not belong to a user'
  end

  test 'has many items' do
    assert_respond_to @product, :items, 'Product does not have items association'
  end

  test 'destroys items when deleted' do
    @product.save!
    @product.items.create!(quantity: 1, list: lists(:one), user: @user)

    assert_difference('Item.count', -1, 'Deleting product did not destroy associated items') do
      @product.destroy
    end
  end

  test 'image attachment' do
    @product.image.attach(io: File.open(Rails.root.join('test/fixtures/files/apple.jpg')),
                          filename: 'apple.jpg', content_type: 'image/jpg')
    assert @product.image.attached?, 'Product image was not attached'
  end

  test 'image content type validation' do
    blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new('test file'),
      filename: 'sample_file.txt',
      content_type: 'text/plain'
    )

    @product.image.attach(blob)
    assert_not @product.valid?, 'Product is valid with incorrect image content type'
  end

  test 'image size validation' do
    blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new('a' * 5.megabytes),
      filename: 'large_file.jpg',
      content_type: 'image/jpeg'
    )
    @product.image.attach(blob)
    assert_not @product.valid?, 'Product is valid with a large image'
  end
end
