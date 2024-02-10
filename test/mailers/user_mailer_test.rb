# frozen_string_literal: true

require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  include ActionView::Helpers::TextHelper
  include Rails.application.routes.url_helpers

  test 'welcome email' do
    user = users(:one)
    email = UserMailer.welcome_email(user).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ['notifications@stockedshelves.com'], email.from
    assert_equal [user.email], email.to
    assert_equal 'Welcome to Stocked Shelves', email.subject
    assert_match(/Welcome to StockedShelves, #{user.username}/, email.html_part.body.to_s)
    assert_match(/To login to the site, just follow/, email.html_part.body.to_s)
    assert_match new_user_session_url, email.html_part.body.to_s
  end

  test 'expiration email' do
    user = users(:one)
    item = items(:one)
    notification = notifications(:one)

    email = UserMailer.expiration_email(user, item, notification).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ['notifications@stockedshelves.com'], email.from
    assert_equal [user.email], email.to
    assert_equal 'Item Expiration Reminder', email.subject
    assert_match(/Reminder: Your item expires soon!/, email.html_part.body.to_s)
    assert_match(/Hello #{user.username},/, email.html_part.body.to_s)
    assert_match(/your item "#{item.product.name}" \(x#{item.quantity}\) will expire in/, email.html_part.body.to_s)
    assert_match pluralize(notification.days_before_expiration, 'day'), email.html_part.body.to_s
    assert_match item_url(item), email.html_part.body.to_s
  end
end
