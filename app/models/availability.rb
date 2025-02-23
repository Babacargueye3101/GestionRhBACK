class Availability < ApplicationRecord
  belongs_to :user
  belongs_to :salon
  has_many :reservations, dependent: :destroy

  validates :date, presence: true
  validates :time_slots, presence: true

end
