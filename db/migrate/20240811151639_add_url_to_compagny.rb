class AddUrlToCompagny < ActiveRecord::Migration[6.1]
  def change
    add_column :compagnies, :url, :string
  end
end
