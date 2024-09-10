class AddCanSeeDashboardToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :can_see_dashboard, :boolean, default: false
  end
end
