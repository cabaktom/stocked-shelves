# frozen_string_literal: true

class List < ApplicationRecord
  include Hashid::Rails

  belongs_to :color, optional: true
  belongs_to :user
  has_many :items, dependent: :destroy

  validates :name, presence: true
end
