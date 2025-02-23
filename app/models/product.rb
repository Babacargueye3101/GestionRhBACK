class Product < ApplicationRecord
  belongs_to :shop
  belongs_to :category
  has_many :sale_items
  has_many :sales, through: :sale_items
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end