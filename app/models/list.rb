class List < ApplicationRecord
  belongs_to :color, optional: true
  belongs_to :user

  validates :name, presence: true
end
