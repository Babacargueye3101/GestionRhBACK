class CreateSalons < ActiveRecord::Migration[7.1]
  def change
    create_table :salons do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.text :description
      t.references :shop, null: false, foreign_key: true
      t.timestamps
    end
  end
end
