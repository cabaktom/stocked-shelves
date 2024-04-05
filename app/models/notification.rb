# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :items

  validates :days_before_expiration, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
