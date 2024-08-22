class Announcement < ApplicationRecord
  belongs_to :user
  belongs_to :compagny

  validates :title, presence: true
  validates :description, presence: true
  validates :date, presence: true
  validates :announcement_type, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
