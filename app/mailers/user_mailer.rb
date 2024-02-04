class UserMailer < ApplicationMailer
  default from: "notifications@stockedshelves.com"

  def welcome_email(user)
    @user = user
    @url = 'http://stockedshelves.com/login'
    mail(to: @user.email, subject: 'Welcome to Stocked Shelves')
  end
end
