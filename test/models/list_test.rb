# frozen_string_literal: true

require 'test_helper'

class ListTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @color = colors(:one)
    @list = List.new(name: 'Groceries', user: @user, color: @color)
  end

  test 'valid list' do
    assert @list.valid?
  end

  test 'invalid without name' do
    @list.name = nil
    assert_not @list.valid?, 'List is valid without a name'
    assert_not_nil @list.errors[:name], 'no validation error for name present'
  end

  test 'belongs to user' do
    assert_respond_to @list, :user, 'List does not belong to a user'
    assert_equal @list.user, @user, 'List user association is not set correctly'
  end

  test 'optional belongs to color' do
    assert_respond_to @list, :color, 'List does not have a color association'
    # Test list is still valid without a color
    @list.color = nil
    assert @list.valid?, 'List is invalid without a color'
  end

  test 'has many items' do
    assert_respond_to @list, :items, 'List does not have items association'
  end

  test 'destroys items when deleted' do
    @list.save!
    @list.items.create!(quantity: 1, user: @user, product: products(:one))

    assert_difference('Item.count', -1, 'Deleting list did not destroy associated items') do
      @list.destroy
    end
  end
end
