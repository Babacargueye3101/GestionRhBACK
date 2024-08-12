class Leave < ApplicationRecord
  belongs_to :employee


  validates :leave_type, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :reason, presence: true
  validates :status, presence: true
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    if end_date < start_date
      errors.add(:end_date, "doit être après la date de début")
    end
  end
end
