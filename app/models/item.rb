class Item < ApplicationRecord
  belongs_to :list
  belongs_to :user
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :expiration, allow_blank: true, comparison: { greater_than_or_equal_to: Proc.new { Date.today } }

  def expired?
    expiration < Date.today
  end
end
