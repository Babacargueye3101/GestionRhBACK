class SubscriptionType < ApplicationRecord
  has_many :subscriptions

  validates :name, :price, :description, :letter, presence: true
  validates :letter, uniqueness: true, length: { is: 1 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
