class AddCanSeeCandidatureToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :can_see_candidature, :boolean, default: false
  end
end
