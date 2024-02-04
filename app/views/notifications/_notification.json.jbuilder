json.extract! notification, :id, :days_before_expiration, :by_email, :user_id, :created_at, :updated_at
json.url notification_url(notification, format: :json)
