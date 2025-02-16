class Category < ApplicationRecord
  belongs_to :shop
  has_many :products, dependent: :destroy

  validates :name, presence: true
end
