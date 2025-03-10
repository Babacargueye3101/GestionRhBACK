class AddDeletedToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :deleted, :boolean, default: false
  end
end
