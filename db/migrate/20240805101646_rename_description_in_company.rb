class RenameDescriptionInCompany < ActiveRecord::Migration[6.1]
  def change
    rename_column :compagnies, :desciption, :description
  end
end
