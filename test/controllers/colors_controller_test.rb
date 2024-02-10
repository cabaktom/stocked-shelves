# frozen_string_literal: true

require 'test_helper'

class ColorsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @color = colors(:one)
    sign_in @user
  end

  test 'should get index' do
    get colors_url
    assert_response :success
    assert_template :index
  end

  test 'should get new' do
    get new_color_url
    assert_response :success
    assert_template :new
  end

  test 'should create color' do
    assert_difference('Color.count') do
      post colors_url, params: { color: { name: 'Green', hex_code: '#00FF00', user_id: @user.id } }
    end

    assert_redirected_to color_url(Color.last)
  end

  test 'should show color' do
    get color_url(@color)
    assert_response :success
    assert_template :show
  end

  test 'should get edit' do
    get edit_color_url(@color)
    assert_response :success
    assert_template :edit
  end

  test 'should update color' do
    patch color_url(@color), params: { color: { name: @color.name, hex_code: @color.hex_code } }
    assert_redirected_to color_url(@color)
  end

  test 'should destroy color' do
    assert_difference('Color.count', -1) do
      delete color_url(@color)
    end

    assert_redirected_to colors_url
  end
end
