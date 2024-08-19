class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.references :employee, null: false, foreign_key: true
      t.date :payment_date
      t.decimal :amount , precision: 10, scale: 2
      t.string :payment_method
      t.string :reference_number
      t.string :status

      t.timestamps
    end
  end
end
