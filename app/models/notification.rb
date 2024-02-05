class Notification < ApplicationRecord
  include Hashid::Rails
  
  belongs_to :user
  has_and_belongs_to_many :item

  validates :days_before_expiration, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
