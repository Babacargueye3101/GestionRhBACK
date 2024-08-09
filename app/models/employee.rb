class Employee < ApplicationRecord
  belongs_to :compagny

  has_attached_file :contract_document
  validates_attachment :contract_document, content_type: { content_type: ["application/pdf", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "image/jpeg", "image/png"] }
end
