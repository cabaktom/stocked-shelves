class Product < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :barcode, presence: false, uniqueness: true
end
