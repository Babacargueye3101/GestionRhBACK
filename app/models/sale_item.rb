class SaleItem < ApplicationRecord
  belongs_to :sale
  belongs_to :product

  validates :quantity, :price, presence: true
end
