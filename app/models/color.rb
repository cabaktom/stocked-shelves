class Color < ApplicationRecord
  has_many :list

  validates :name, presence: true
  validates :hex_code, presence: true, format: { with: /\A#(?:\h{3}){1,2}\z/ }  
end
