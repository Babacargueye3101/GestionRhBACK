class CreateSubscriptionTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :subscription_types do |t|
      t.string :name
      t.decimal :price
      t.text :description
      t.string :letter
      t.boolean :active, default: true
      t.timestamps
    end
    add_index :subscription_types, :letter, unique: true
  end
end
