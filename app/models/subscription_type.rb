class SubscriptionType < ApplicationRecord
  has_many :subscriptions

  validates :name, :price, :description, :letter, presence: true
  validates :letter, uniqueness: true, length: { is: 1 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  # Scope pour récupérer les types d'abonnement non supprimés
  scope :active, -> { where(deleted: false) }

  # Scope pour récupérer les types d'abonnement supprimés
  scope :deleted, -> { where(deleted: true) }
end
