class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :client_name
      t.string :client_phone
      t.string :client_address
      t.decimal :total
      t.string :status
      t.string :payment_method
      t.string :mobile_phone

      t.timestamps
    end
  end
end