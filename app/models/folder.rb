class Folder < ApplicationRecord
  has_many :documents, dependent: :destroy
  belongs_to :compagny

  validates :name, presence: true
  validates :compagny_id, presence: true
end
