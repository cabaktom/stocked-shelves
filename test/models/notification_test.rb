# frozen_string_literal: true

require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @notification = Notification.new(days_before_expiration: 3, user: @user)
  end

  test 'valid notification' do
    assert @notification.valid?
  end

  test 'invalid without days_before_expiration' do
    @notification.days_before_expiration = nil
    assert_not @notification.valid?, 'Notification is valid without days_before_expiration'
    assert_not_nil @notification.errors[:days_before_expiration],
                   'no validation error for days_before_expiration present'
  end

  test 'days_before_expiration must be an integer greater than 0' do
    invalid_values = [0, -1, 1.5, 'two']
    invalid_values.each do |invalid_value|
      @notification.days_before_expiration = invalid_value
      assert_not @notification.valid?, "#{invalid_value.inspect} should be invalid for days_before_expiration"
    end
  end

  test 'belongs to user' do
    assert_respond_to @notification, :user, 'Notification does not belong to a user'
  end

  test 'has and belongs to many items' do
    assert_respond_to @notification, :item, 'Notification does not have items association'
  end

  test 'can add item to notification' do
    item = items(:one)
    @notification.item << item
    assert_includes @notification.item, item, 'Item was not added to the notification'
  end
end
