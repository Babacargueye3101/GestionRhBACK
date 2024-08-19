class Payment < ApplicationRecord
  belongs_to :employee
  # Validations
  validates :employee, presence: true
  validates :payment_date, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_method, presence: true
  validates :reference_number, presence: true
  validates :status, presence: true

  # Scopes (si nécessaire)
  scope :recent, -> { order(payment_date: :desc) }
  scope :by_employee, ->(employee_id) { where(employee_id: employee_id) }
end
