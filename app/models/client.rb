class Client < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :name, :surname, :email, :phone, presence: true
  validates :email, uniqueness: true
  validates :phone, uniqueness: true
end
