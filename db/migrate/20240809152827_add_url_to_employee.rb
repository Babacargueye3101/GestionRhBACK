class AddUrlToEmployee < ActiveRecord::Migration[6.1]
  def change
    add_column :employees, :url, :string
  end
end
