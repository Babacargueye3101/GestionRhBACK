class RemovePaperclipColumnsFromCompanies < ActiveRecord::Migration[7.2]
  def change
    if column_exists?(:compagnies, :logo_file_name)
      remove_column :compagnies, :logo_file_name
    end

    if column_exists?(:compagnies, :logo_content_type)
      remove_column :compagnies, :logo_content_type
    end

    if column_exists?(:compagnies, :logo_file_size)
      remove_column :compagnies, :logo_file_size
    end

    if column_exists?(:compagnies, :logo_updated_at)
      remove_column :compagnies, :logo_updated_at
    end
  end
end
