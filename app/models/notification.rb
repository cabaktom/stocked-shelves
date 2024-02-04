class Notification < ApplicationRecord
  belongs_to :user

  validates :days_before_expiration, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
