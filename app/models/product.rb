class Product < ApplicationRecord
  belongs_to :shop
  belongs_to :category
  has_many :sale_items
  has_many :sales, through: :sale_items
  has_many :order_items
  has_many :variants, dependent: :destroy  # ✅ Un produit peut avoir plusieurs variantes
  has_one_attached :image  # 📸 Gère une image unique par produit
  
  # Validations
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  # Callbacks
  before_destroy :create_history_and_update_references
  
  private
  
  # Crée une entrée d'historique pour ce produit et met à jour les références
  def create_history_and_update_references
    # Créer un enregistrement d'historique pour ce produit
    product_history = ProductHistory.create_from_product(self)
    
    # Traiter les OrderItems associés
    order_items.each do |order_item|
      OrderItemHistory.create_from_order_item(order_item)
    end
    
    # Traiter les SaleItems associés
    sale_items.each do |sale_item|
      SaleItemHistory.create_from_sale_item(sale_item)
    end
    
    # Déréférencer les foreign keys dans OrderItem
    ActiveRecord::Base.connection.execute("UPDATE order_items SET product_id = NULL WHERE product_id = #{self.id}")
    
    # Déréférencer les foreign keys dans SaleItem
    ActiveRecord::Base.connection.execute("UPDATE sale_items SET product_id = NULL WHERE product_id = #{self.id}")
  end
end