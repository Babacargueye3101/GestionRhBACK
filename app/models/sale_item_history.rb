class SaleItemHistory < ApplicationRecord
  # Relations
  belongs_to :sale, optional: true
  
  # Validations
  validates :quantity, :price, presence: true
  
  # Méthode pour créer un historique à partir d'un élément de vente
  def self.create_from_sale_item(sale_item)
    product = Product.find_by(id: sale_item.product_id)
    product_name = product&.name || "Produit supprimé"
    
    create(
      sale_id: sale_item.sale_id,
      product_id: sale_item.product_id,
      quantity: sale_item.quantity,
      price: sale_item.price,
      product_name: product_name
    )
  end
end
