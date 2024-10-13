class Document < ApplicationRecord
  belongs_to :folder
  has_one_attached :file

  # Validation pour Active Storage
  validates :file, presence: true
  validate :correct_file_mime_type

  private

  def correct_file_mime_type
    if file.attached? && !file.content_type.in?(%('application/pdf image/jpeg image/png'))
      errors.add(:file, 'must be a PDF, JPEG, or PNG')
    elsif file.attached? == false
      errors.add(:file, 'is required')
    end
  end
end
