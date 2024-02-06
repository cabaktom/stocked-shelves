class UserMailer < ApplicationMailer
  default from: "notifications@stockedshelves.com"

  def welcome_email(user)
    @user = user
    @url = new_user_session_url
    mail(to: @user.email, subject: 'Welcome to Stocked Shelves')
  end

  def expiration_email(user, item, notification)
    @user = user
    @item = item
    @notification = notification
    @url = item_url(@item)
    mail(to: @user.email, subject: 'Item Expiration Reminder')
  end
end
