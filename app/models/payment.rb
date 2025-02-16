class Payment < ApplicationRecord
  belongs_to :sale

  validates :amount, numericality: { greater_than: 0 }
end
