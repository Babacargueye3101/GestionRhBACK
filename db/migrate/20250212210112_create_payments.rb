class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :sale, null: false, foreign_key: true
      t.decimal :amount
      t.datetime :payment_date
      t.datetime :next_payment_date

      t.timestamps
    end
  end
end
