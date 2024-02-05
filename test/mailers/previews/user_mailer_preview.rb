# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    user = User.new(id: 1, email: 'test@example.com', username: 'test_user')
    UserMailer.welcome_email(user)
  end

  def expiration_email
    user = User.new(id: 1, email: 'test@example.com', username: 'test_user')
    item = Item.new(id: 1, expiration: Date.today + 1.week, quantity: 1, product: Product.new(name: 'Test Product'))
    notification = Notification.new(days_before_expiration: 7)

    UserMailer.expiration_email(user, item, notification)
  end
end
