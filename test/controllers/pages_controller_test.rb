# frozen_string_literal: true

require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
  end

  test 'should get home for unauthenticated users' do
    get root_url
    assert_response :success
    assert_template :home
  end

  test 'should redirect to dashboard when user is signed in' do
    sign_in @user
    get root_url
    assert_redirected_to dashboard_url
  end

  test 'should get dashboard for authenticated users' do
    sign_in @user
    get dashboard_url
    assert_response :success
    assert_template :dashboard
  end

  test 'should redirect unauthenticated users from dashboard to sign in' do
    get dashboard_url
    assert_redirected_to new_user_session_url
    assert_equal 'You need to sign in or sign up before continuing.', flash[:alert]
  end
end
