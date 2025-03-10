class Client < ApplicationRecord
  has_many :reservations, dependent: :destroy
  has_many :subscriptions

  validates :name, :surname, :email, :phone, presence: true
  validates :email, uniqueness: true
  validates :phone, uniqueness: true
   # Marquer le client comme supprimé
   def soft_delete
    update(deleted: true)
  end

  # Scope pour récupérer les clients non supprimés
  scope :active, -> { where(deleted: false) }
  
  # Scope pour récupérer les clients supprimés
  scope :deleted, -> { where(deleted: true) }

  # Scope pour récupérer les clients par nom
  scope :by_name, ->(name) { where("name LIKE ?", "%#{name}%") }

  # Scope pour récupérer les clients par email
  scope :by_email, ->(email) { where("email LIKE ?", "%#{email}%") }

  # Scope pour récupérer les clients par téléphone
  scope :by_phone, ->(phone) { where("phone LIKE ?", "%#{phone}%") }

  # Scope pour récupérer les clients par nom et email
  scope :by_name_and_email, ->(name, email) { by_name(name).by_email(email) }

  # Scope pour récupérer les clients par nom et téléphone
  scope :by_name_and_phone, ->(name, phone) { by_name(name).by_phone(phone) }

  # Scope pour récupérer les clients par email
end
