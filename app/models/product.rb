class Product < ApplicationRecord
  include Hashid::Rails
  
  belongs_to :user
  has_many :items, dependent: :destroy

  validates :name, presence: true
  validates :barcode, presence: false, uniqueness: true, allow_blank: true
end
