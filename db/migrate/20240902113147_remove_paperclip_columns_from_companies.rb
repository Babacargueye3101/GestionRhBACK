class RemovePaperclipColumnsFromCompanies < ActiveRecord::Migration[7.2]
  def change
    remove_column :compagnies, :logo_file_name, :string
    remove_column :compagnies, :logo_content_type, :string
    remove_column :compagnies, :logo_file_size, :integer
    remove_column :compagnies, :logo_updated_at, :datetime
  end
end
