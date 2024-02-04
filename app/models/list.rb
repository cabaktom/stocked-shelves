class List < ApplicationRecord
  belongs_to :color, optional: true
  belongs_to :user
  has_many :items, dependent: :destroy

  validates :name, presence: true
end
