class CreateOrderItemHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :order_item_histories do |t|
      t.integer :order_id
      t.integer :product_id
      t.integer :variant_id
      t.integer :quantity
      t.decimal :price, precision: 10, scale: 2
      t.json :variant_details
      t.string :product_name  # Ajouter le nom du produit pour référence

      t.timestamps
    end
    
    add_index :order_item_histories, :order_id
    add_index :order_item_histories, :product_id
    add_index :order_item_histories, :variant_id
  end
end
