class Variant < ApplicationRecord
  belongs_to :product
  has_many :order_items
  validates :name, :stock, presence: true
end
