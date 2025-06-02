class OrderItemHistory < ApplicationRecord
  # Relations
  belongs_to :order, optional: true
  
  # Validations
  validates :quantity, :price, presence: true
  
  # Méthode pour créer un historique à partir d'un élément de commande
  def self.create_from_order_item(order_item)
    product = Product.find_by(id: order_item.product_id)
    product_name = product&.name || "Produit supprimé"
    
    create(
      order_id: order_item.order_id,
      product_id: order_item.product_id,
      variant_id: order_item.variant_id,
      quantity: order_item.quantity,
      price: order_item.price,
      variant_details: order_item.variant_details,
      product_name: product_name
    )
  end
end
