class Employee < ApplicationRecord
  belongs_to :compagny
  has_many :leaves
  has_many :payments

  has_one_attached :contract_document


  def full_name
    "#{first_name} #{last_name}".upcase
  end
end
