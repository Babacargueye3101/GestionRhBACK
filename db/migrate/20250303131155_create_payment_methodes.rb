class CreatePaymentMethodes < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_methodes do |t|
      t.string :name

      t.timestamps
    end
  end
end
