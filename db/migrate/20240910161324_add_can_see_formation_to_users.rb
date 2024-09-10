class AddCanSeeFormationToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :can_see_formation, :boolean, default: false
  end
end
