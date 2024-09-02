class Compagny < ApplicationRecord
  has_many :users
  has_many :announcements
  has_many :appointments

  has_one_attached :logo
end
