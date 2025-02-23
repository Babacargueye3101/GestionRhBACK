class Salon < ApplicationRecord
  belongs_to :shop
  has_many :services, dependent: :destroy
  has_many :availabilities, dependent: :destroy

  validates :name, presence: true
end
