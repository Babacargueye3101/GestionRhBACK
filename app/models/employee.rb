class Employee < ApplicationRecord
  belongs_to :compagny
  has_many :leaves
  has_many :payments

  has_attached_file :contract_document
  validates_attachment_content_type :contract_document, content_type: ["application/pdf"]


  def full_name
    "#{first_name} #{last_name}".upcase
  end
end
