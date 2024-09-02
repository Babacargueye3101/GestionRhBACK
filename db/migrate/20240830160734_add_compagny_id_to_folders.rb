class AddCompagnyIdToFolders < ActiveRecord::Migration[7.2]
  def change
    add_column :folders, :compagny_id, :integer
    add_index :folders, :compagny_id
  end
end
