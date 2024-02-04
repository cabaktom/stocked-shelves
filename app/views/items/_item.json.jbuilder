json.extract! item, :id, :quantity, :expiration, :expired, :list_id, :user_id, :product_id, :created_at, :updated_at
json.url item_url(item, format: :json)
