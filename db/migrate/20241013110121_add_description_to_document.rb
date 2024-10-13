class AddDescriptionToDocument < ActiveRecord::Migration[7.2]
  def change
    add_column :documents, :description, :string
  end
end
