# frozen_string_literal: true

require 'test_helper'

class EmailExpirationNotificationJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  setup do
    @user = users(:one)
    @item = items(:one)
    @notification = notifications(:one)
    @item.update(notification_ids: [@notification.id])
    @original_expiration = @item.expiration
  end

  teardown do
    # Ensure that each test starts with an empty email deliveries array
    # - the issue was in the job_discards_on_DeserializationError test when it failed on every other run
    ActionMailer::Base.deliveries.clear
  end

  test 'should send expiration email if conditions met' do
    assert_emails 1 do
      EmailExpirationNotificationJob.perform_now(@user, @item, @original_expiration, @notification)
    end
  end

  test 'should not send email if user opts out of email notifications' do
    @user.update(notify_through_email: false)

    assert_no_emails do
      EmailExpirationNotificationJob.perform_now(@user, @item, @original_expiration, @notification)
    end
  end

  test 'should not send email if item expiration has changed' do
    new_expiration = @original_expiration + 1.day
    @item.update(expiration: new_expiration)

    assert_no_emails do
      EmailExpirationNotificationJob.perform_now(@user, @item, @original_expiration, @notification)
    end
  end

  test "should not send email if notification not included in item's notifications" do
    another_notification = Notification.create!(user: @user, days_before_expiration: 3)

    assert_no_emails do
      EmailExpirationNotificationJob.perform_now(@user, @item, @original_expiration, another_notification)
    end
  end

  test 'should not send email if item is used' do
    @item.update(used: true)

    assert_no_emails do
      EmailExpirationNotificationJob.perform_now(@user, @item, @original_expiration, @notification)
    end
  end

  test 'job discards on DeserializationError' do
    @item.destroy

    perform_enqueued_jobs do
      EmailExpirationNotificationJob.perform_later(@user, @item, @original_expiration, @notification)
    end

    assert_no_emails
  end
end
