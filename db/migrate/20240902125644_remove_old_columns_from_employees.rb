class RemoveOldColumnsFromEmployees < ActiveRecord::Migration[7.2]
  def change
    def change
      remove_column :employees, :logo_file_name, :string, if_exists: true
      remove_column :employees, :logo_content_type, :string, if_exists: true
      remove_column :employees, :logo_file_size, :integer, if_exists: true
      remove_column :employees, :logo_updated_at, :datetime, if_exists: true
    end
  end
end
