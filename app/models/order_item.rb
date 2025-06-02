# app/models/order_item.rb
class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product, optional: true  # Rendre optionnel pour permettre la suppression du produit
  belongs_to :variant, optional: true
  validates :quantity, :price, presence: true

  before_save :set_variant_details
  
  # Méthode pour accéder au nom du produit, même s'il a été supprimé
  def product_name
    if product.present?
      product.name
    else
      # Rechercher dans l'historique
      history = OrderItemHistory.find_by(order_id: order_id, product_id: product_id)
      history&.product_name || "Produit supprimé"
    end
  end
  
  private
  
  def set_variant_details
    return unless variant.present?
    
    self.variant_details = {
      name: variant.name
    }
  end
end