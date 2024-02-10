# frozen_string_literal: true

class Color < ApplicationRecord
  include Hashid::Rails

  has_many :list, dependent: :nullify
  belongs_to :user

  validates :name, presence: true
  validates :hex_code, presence: true, format: { with: /\A#(?:\h{3}){1,2}\z/ }
end
