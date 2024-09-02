class Document < ApplicationRecord
  belongs_to :folder
  has_one_attached :file

  # Validation pour Active Storage
  # validates :file, content_type: { in: ['application/pdf'], message: 'must be a PDF' }
end
