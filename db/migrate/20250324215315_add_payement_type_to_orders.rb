class AddPayementTypeToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :payement_type, :string
  end
end
