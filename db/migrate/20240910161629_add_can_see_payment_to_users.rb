class AddCanSeePaymentToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :can_see_paies, :boolean, default: false
  end
end
