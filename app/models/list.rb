class List < ApplicationRecord
  belongs_to :color, optional: true

  validates :name, presence: true
end
