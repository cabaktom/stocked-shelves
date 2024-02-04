class Item < ApplicationRecord
  belongs_to :list
  belongs_to :user
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
