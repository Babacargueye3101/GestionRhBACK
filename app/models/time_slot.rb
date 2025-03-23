# app/models/time_slot.rb
class TimeSlot < ApplicationRecord
  validates :start_time, :end_time, presence: true
end