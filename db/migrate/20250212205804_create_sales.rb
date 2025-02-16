class CreateSales < ActiveRecord::Migration[7.1]
  def change
    create_table :sales do |t|
      t.string :buyer_name
      t.string :buyer_surname
      t.string :channel
      t.decimal :total_price
      t.decimal :paid_amount
      t.decimal :remaining_amount
      t.string :payment_method
      t.boolean :delivered
      t.datetime :sale_date
      t.references :user, null: false, foreign_key: true
      t.references :shop, null: false, foreign_key: true

      t.timestamps
    end
  end
end
