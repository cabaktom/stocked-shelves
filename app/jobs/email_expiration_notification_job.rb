class EmailExpirationNotificationJob < ApplicationJob
  queue_as :mailers

  def perform(user_id, item_id, item_expiration, notification_id)
    # Non-existent items and notifications throw DeserializationError that is caught and discarded by ApplicationJob
    user = User.find_by(id: user_id)
    item = Item.find_by(id: item_id)
    notification = Notification.find_by(id: notification_id)

    return unless user.notify_through_email # User has opted out of email notifications after scheduling this job
    return unless item.expiration == item_expiration
    return unless item.notification.include?(notification)

    UserMailer.expiration_email(item.user, item, notification).deliver_now
  end
end
