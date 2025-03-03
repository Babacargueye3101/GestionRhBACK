class Personnel < ApplicationRecord
  has_many :personnel_shops, dependent: :destroy
  has_many :shops, through: :personnel_shops
  has_many :salons, through: :personnel_shops
  belongs_to :user, optional: true  # Un personnel peut être lié à un user

  validates :first_name, :last_name, :phone, presence: true
  validates :email, uniqueness: true, allow_nil: true
  validates :phone, uniqueness: true
end
