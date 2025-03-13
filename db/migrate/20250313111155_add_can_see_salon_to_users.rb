class AddCanSeeSalonToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :can_see_salon, :boolean, default: false
  end
end
