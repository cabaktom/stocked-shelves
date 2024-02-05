class UserMailer < ApplicationMailer
  default from: "notifications@stockedshelves.com"

  def welcome_email(user)
    @user = user
    @url = 'http://stockedshelves.com/login'
    mail(to: @user.email, subject: 'Welcome to Stocked Shelves')
  end

  def expiration_email(user, item, notification)
    @user = user
    @item = item
    @notification = notification
    @url = "http://stockedshelves.com/items/#{item.id}"
    mail(to: @user.email, subject: 'Item Expiration Reminder')
  end
end
