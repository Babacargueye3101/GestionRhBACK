class AddCompagnyIdToPayment < ActiveRecord::Migration[6.1]
  def change
    add_column :payments, :compagny_id, :integer
  end
end
