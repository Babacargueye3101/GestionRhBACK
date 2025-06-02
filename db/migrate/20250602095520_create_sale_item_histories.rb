class CreateSaleItemHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :sale_item_histories do |t|
      t.integer :sale_id
      t.integer :product_id
      t.integer :quantity
      t.decimal :price, precision: 10, scale: 2
      t.string :product_name  # Ajouter le nom du produit pour référence

      t.timestamps
    end
    
    add_index :sale_item_histories, :sale_id
    add_index :sale_item_histories, :product_id
  end
end
