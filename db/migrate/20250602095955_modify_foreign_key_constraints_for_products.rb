class ModifyForeignKeyConstraintsForProducts < ActiveRecord::Migration[7.2]
  def change
    # Modifier la table order_items
    change_column_null :order_items, :product_id, true
    
    # Supprimer la contrainte de clé étrangère existante sur order_items
    remove_foreign_key :order_items, :products, if_exists: true
    # Ajouter une nouvelle contrainte qui permet les valeurs NULL
    add_foreign_key :order_items, :products, on_delete: :nullify, validate: false
    
    # Modifier la table sale_items
    change_column_null :sale_items, :product_id, true
    
    # Supprimer la contrainte de clé étrangère existante sur sale_items
    remove_foreign_key :sale_items, :products, if_exists: true
    # Ajouter une nouvelle contrainte qui permet les valeurs NULL
    add_foreign_key :sale_items, :products, on_delete: :nullify, validate: false
  end
end
