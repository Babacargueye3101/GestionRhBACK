class Shop < ApplicationRecord
  has_many :products
  has_many :user_shops
  belongs_to :user
  has_many :sales, dependent: :destroy
  has_many :categories, dependent: :destroy
end
