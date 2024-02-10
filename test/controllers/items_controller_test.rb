# frozen_string_literal: true

require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActiveJob::TestHelper

  setup do
    @user = users(:one)
    @item = items(:one)
    sign_in @user
  end

  test 'should get index' do
    get items_url
    assert_response :success
    assert_template :index
  end

  test 'should get new' do
    get new_item_url
    assert_response :success
    assert_template :new
  end

  test 'should create item' do
    assert_difference('Item.count') do
      post items_url,
           params: { item: { quantity: 2, list_id: lists(:one).id, product_id: products(:one).id,
                             expiration: Date.tomorrow, notification_ids: [notifications(:one).id] } }
    end

    assert_redirected_to item_url(Item.last)
  end

  test 'should show item' do
    get item_url(@item)
    assert_response :success
    assert_template :show
  end

  test 'should get edit' do
    get edit_item_url(@item)
    assert_response :success
    assert_template :edit
  end

  test 'should update item' do
    patch item_url(@item),
          params: { item: { quantity: 3, list_id: @item.list_id, product_id: @item.product_id,
                            expiration: @item.expiration,
                            notification_ids: [notifications(:one).id, notifications(:two).id] } }
    assert_redirected_to item_url(@item)
  end

  test 'should destroy item' do
    assert_difference('Item.count', -1) do
      delete item_url(@item)
    end

    assert_redirected_to items_url
  end

  test 'should schedule expiration notification on create' do
    assert_enqueued_with(job: EmailExpirationNotificationJob) do
      post items_url,
           params: { item: { quantity: 1, list_id: lists(:one).id, product_id: products(:one).id,
                             expiration: 3.days.from_now, notification_ids: [notifications(:one).id] } }
    end
  end

  test 'should schedule expiration notification on update' do
    assert_enqueued_with(job: EmailExpirationNotificationJob) do
      patch item_url(@item),
            params: { item: { quantity: 1, list_id: @item.list_id, product_id: @item.product_id,
                              expiration: 3.days.from_now,
                              notification_ids: [notifications(:one).id, notifications(:two).id] } }
    end
  end

  test 'should not schedule expiration notification on create because user has emails turned off' do
    @user = users(:two)
    sign_in @user
    @item = items(:three)

    assert_no_enqueued_jobs do
      post items_url,
           params: { item: { quantity: 1, list_id: lists(:three).id, product_id: products(:three).id,
                             expiration: 3.days.from_now, notification_ids: [notifications(:three).id] } }
    end
  end

  test 'should not schedule expiration notification on update because user has emails turned off' do
    @user = users(:two)
    sign_in @user
    @item = items(:three)

    assert_no_enqueued_jobs do
      patch item_url(@item),
            params: { item: { quantity: 1, list_id: @item.list_id, product_id: @item.product_id,
                              expiration: 3.days.from_now,
                              notification_ids: [notifications(:three).id, notifications(:four).id] } }
    end
  end

  test 'should not schedule expiration notification on create because item has no expiration' do
    assert_no_enqueued_jobs do
      post items_url,
           params: { item: { quantity: 1, list_id: lists(:one).id, product_id: products(:one).id,
                             expiration: nil, notification_ids: [notifications(:one).id] } }
    end
  end

  test 'should not schedule expiration notification on update because item has no expiration' do
    assert_no_enqueued_jobs do
      patch item_url(@item),
            params: { item: { quantity: 1, list_id: @item.list_id, product_id: @item.product_id,
                              expiration: nil,
                              notification_ids: [notifications(:one).id, notifications(:two).id] } }
    end
  end

  test 'should not schedule expiration notification on create because item is expired' do
    assert_no_enqueued_jobs do
      post items_url,
           params: { item: { quantity: 1, list_id: lists(:one).id, product_id: products(:one).id,
                             expiration: 3.days.ago, notification_ids: [notifications(:one).id] } }
    end
  end

  test 'should not schedule expiration notification on update because item is expired' do
    assert_no_enqueued_jobs do
      patch item_url(@item),
            params: { item: { quantity: 1, list_id: @item.list_id, product_id: @item.product_id,
                              expiration: 3.days.ago,
                              notification_ids: [notifications(:one).id, notifications(:two).id] } }
    end
  end

  test 'should not schedule expiration notification on create because item is used' do
    assert_no_enqueued_jobs do
      post items_url,
           params: { item: { quantity: 1, list_id: lists(:one).id, product_id: products(:one).id,
                             expiration: 3.days.from_now, used: true,
                             notification_ids: [notifications(:one).id] } }
    end
  end

  test 'should not schedule expiration notification on update because item is used' do
    assert_no_enqueued_jobs do
      patch item_url(@item),
            params: { item: { quantity: 1, list_id: @item.list_id, product_id: @item.product_id,
                              expiration: 3.days.from_now, used: true,
                              notification_ids: [notifications(:one).id, notifications(:two).id] } }
    end
  end
end
