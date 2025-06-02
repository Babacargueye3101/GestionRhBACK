class CreateProductHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :product_histories do |t|
      t.string :name
      t.text :description
      t.decimal :price, precision: 10, scale: 2
      t.integer :stock
      t.integer :product_id
      t.integer :shop_id
      t.integer :category_id
      t.json :product_data

      t.timestamps
    end
    
    add_index :product_histories, :product_id
    add_index :product_histories, :shop_id
    add_index :product_histories, :category_id
  end
end
