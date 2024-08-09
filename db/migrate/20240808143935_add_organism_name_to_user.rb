class AddOrganismNameToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :organismName, :string
  end
end
