class SaleItem < ApplicationRecord
  belongs_to :sale
  belongs_to :product, optional: true  # Rendre optionnel pour permettre la suppression du produit

  validates :quantity, :price, presence: true
  
  # Méthode pour accéder au nom du produit, même s'il a été supprimé
  def product_name
    if product.present?
      product.name
    else
      # Rechercher dans l'historique
      history = SaleItemHistory.find_by(sale_id: sale_id, product_id: product_id)
      history&.product_name || "Produit supprimé"
    end
  end
end
