# frozen_string_literal: true

require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @notification = notifications(:one)
    sign_in @user
  end

  test 'should get index' do
    get notifications_url
    assert_response :success
    assert_template :index
  end

  test 'should get new' do
    get new_notification_url
    assert_response :success
    assert_template :new
  end

  test 'should create notification' do
    assert_difference('Notification.count') do
      post notifications_url, params: { notification: { days_before_expiration: 10, user_id: @user.id } }
    end

    assert_redirected_to notification_url(Notification.last)
  end

  test 'should show notification' do
    get notification_url(@notification)
    assert_response :success
    assert_template :show
  end

  test 'should get edit' do
    get edit_notification_url(@notification)
    assert_response :success
    assert_template :edit
  end

  test 'should update notification' do
    patch notification_url(@notification), params: { notification: { days_before_expiration: 12 } }
    assert_redirected_to notification_url(@notification)
  end

  test 'should destroy notification' do
    assert_difference('Notification.count', -1) do
      delete notification_url(@notification)
    end

    assert_redirected_to notifications_url
  end
end
