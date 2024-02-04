class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :lists, dependent: :destroy
  has_many :colors, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :notifications, dependent: :destroy
end
