class ProductHistory < ApplicationRecord
  # Relations
  belongs_to :shop, optional: true
  belongs_to :category, optional: true
  
  # Validations
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  
  # Méthode pour créer un historique à partir d'un produit
  def self.create_from_product(product)
    create(
      name: product.name,
      description: product.description,
      price: product.price,
      stock: product.stock,
      product_id: product.id,
      shop_id: product.shop_id,
      category_id: product.category_id,
      product_data: {
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        stock: product.stock,
        created_at: product.created_at,
        updated_at: product.updated_at
      }
    )
  end
end
