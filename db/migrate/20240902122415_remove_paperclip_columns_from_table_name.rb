class RemovePaperclipColumnsFromTableName < ActiveRecord::Migration[7.2]
  def change
    remove_column :employees, :logo_file_name, :string
    remove_column :employees, :logo_content_type, :string
    remove_column :employees, :logo_file_size, :integer
    remove_column :employees, :logo_updated_at, :datetime
  end
end
