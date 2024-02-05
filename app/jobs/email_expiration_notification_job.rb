class EmailExpirationNotificationJob < ApplicationJob
  queue_as :mailers

  def perform(item_id, notification_id)
    item = Item.find_by(id: item_id)
    notification = Notification.find_by(id: notification_id)

    puts "Sending expiration email"
    # UserMailer.expiration_email(item.user, item).deliver_now
  end
end
