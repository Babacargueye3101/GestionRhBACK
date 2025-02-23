class Service < ApplicationRecord
  belongs_to :salon

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :duration, numericality: { greater_than: 0 }
end
