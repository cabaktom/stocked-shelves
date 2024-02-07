# frozen_string_literal: true

# Find or create the demo user
user = User.find_or_create_by(email: 'demo@example.com') do |u|
  u.password = 'password'
  u.password_confirmation = 'password'
  u.username = 'demo_user'
end

# Create colors if they don't exist
colors_data = [
  { name: 'Red', hex_code: '#FF0000' },
  { name: 'Green', hex_code: '#00FF00' },
  { name: 'Blue', hex_code: '#0000FF' }
]
colors_data.map do |color_data|
  Color.find_or_create_by(color_data) { |color| color.user = user }
end

# Create lists if they don't exist, ensuring colors are associated correctly
lists_attributes = [
  { name: 'Fridge', color_name: 'Red' },
  { name: 'Pantry', color_name: 'Green' },
  { name: 'Freezer', color_name: 'Blue' }
]
lists = lists_attributes.map do |attrs|
  List.find_or_create_by(name: attrs[:name], user:) do |list|
    list.color = Color.find_by(name: attrs[:color_name], user:)
  end
end

# Create notifications if they don't exist
days_before_expiration = [1, 3, 5, 10]
notifications = days_before_expiration.map do |days|
  Notification.find_or_create_by(days_before_expiration: days, user:)
end

# Create products if they don't exist
product_names = ['Apple', 'Milk', 'Eggs', 'Bread', 'Butter', 'Cheese', 'Chicken', 'Beef', 'Pork', 'Fish', 'Shrimp',
                 'Rice', 'Pasta', 'Tomato Sauce']
products = product_names.map do |name|
  Product.find_or_create_by(name:, user:) do |product|
    product.barcode = SecureRandom.hex(6)
  end
end

# Create items
30.times do |n|
  item = Item.new(
    quantity: (n % 15) + 1,
    expiration: Date.today + ((n % 30) - 10).days,
    used: (n % 6).zero?,
    list: lists[n % lists.length],
    product: products[n % products.length],
    user:
  )
  item.save(validate: false) # Allow to import items with expired dates
end

# Assign a fixed number of notifications to each item
Item.find_each.with_index do |item, index|
  selected_notifications = notifications[(index % notifications.length)...((index % notifications.length) + 2)]
  item.notification << selected_notifications
end

puts 'Demo data seeded.'
