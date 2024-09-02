class Document < ApplicationRecord
  belongs_to :folder
  has_one_attached :file
  validates_attachment :file, content_type: { content_type: ["application/pdf"] }

end
