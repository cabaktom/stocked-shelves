# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :user
  has_many :items, dependent: :destroy
  has_one_attached :image

  validates :name, presence: true
  validates :barcode, presence: false, uniqueness: true, allow_blank: true
  validates :image, attached: false, content_type: ['image/png', 'image/jpg', 'image/jpeg'],
                    size: { less_than: 5.megabytes }, limit: { min: 0, max: 1 }
end
