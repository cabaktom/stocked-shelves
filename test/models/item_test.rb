# frozen_string_literal: true

require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @list = lists(:one)
    @product = products(:one)
    @item = Item.new(quantity: 5, expiration: Date.tomorrow, list: @list, user: @user, product: @product)
  end

  test 'valid item' do
    assert @item.valid?
  end

  test 'invalid without quantity' do
    @item.quantity = nil
    assert_not @item.valid?, 'Item is valid without a quantity'
    assert_not_nil @item.errors[:quantity], 'no validation error for quantity present'
  end

  test 'quantity must be an integer' do
    @item.quantity = 2.5
    assert_not @item.valid?, 'Item is valid with a non-integer quantity'
    assert_not_nil @item.errors[:quantity], 'no validation error for non-integer quantity'
  end

  test 'quantity must be greater than 0' do
    @item.quantity = 0
    assert_not @item.valid?, 'Item is valid with a quantity of 0'
    assert_not_nil @item.errors[:quantity], 'no validation error for quantity less than 1'
  end

  test 'expiration is optional but must be in the future' do
    @item.expiration = Date.yesterday
    assert_not @item.valid?, 'Item is valid with a past expiration date'
    @item.expiration = Date.today
    assert @item.valid?, 'Item is invalid with today as the expiration date'
    @item.expiration = nil
    assert @item.valid?, 'Item is invalid without an expiration date'
  end

  test 'expired? method returns correct value' do
    @item.expiration = Date.tomorrow
    assert_not @item.expired?, 'Item is incorrectly marked as expired'
    @item.expiration = Date.yesterday
    assert @item.expired?, 'Item is incorrectly marked as not expired'
    @item.used = true
    assert_not @item.expired?, 'Item is incorrectly marked as expired when used'
  end

  test 'should belong to a list' do
    assert_respond_to @item, :list, 'Item does not belong to a list'
  end

  test 'should belong to a user' do
    assert_respond_to @item, :user, 'Item does not belong to a user'
  end

  test 'should belong to a product' do
    assert_respond_to @item, :product, 'Item does not belong to a product'
  end

  test 'should have and belong to many notifications' do
    assert_respond_to @item, :notification, 'Item does not have and belong to many notifications'
  end
end
