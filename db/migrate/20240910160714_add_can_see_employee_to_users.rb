class AddCanSeeEmployeeToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :can_see_employee, :boolean, default: false
  end
end
