# frozen_string_literal: true

require 'test_helper'

class ListsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @list = lists(:one)
    sign_in @user
  end

  test 'should get index' do
    get lists_url
    assert_response :success
    assert_template :index
  end

  test 'should get new' do
    get new_list_url
    assert_response :success
    assert_template :new
  end

  test 'should create list' do
    assert_difference('List.count') do
      post lists_url, params: { list: { name: 'New List', color_id: colors(:one).id, user_id: @user.id } }
    end

    assert_redirected_to list_url(List.last)
  end

  test 'should show list' do
    get list_url(@list)
    assert_response :success
    assert_template :show
  end

  test 'should get edit' do
    get edit_list_url(@list)
    assert_response :success
    assert_template :edit
  end

  test 'should update list' do
    patch list_url(@list), params: { list: { name: 'Updated List', color_id: @list.color_id } }
    assert_redirected_to list_url(@list)
  end

  test 'should destroy list' do
    assert_difference('List.count', -1) do
      delete list_url(@list)
    end

    assert_redirected_to lists_url
  end
end
