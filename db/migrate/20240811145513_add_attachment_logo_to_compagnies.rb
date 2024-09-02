class AddAttachmentLogoToCompagnies < ActiveRecord::Migration[6.1]
  def change
    add_column :compagnies, :logo_file_name, :string
    add_column :compagnies, :logo_content_type, :string
    add_column :compagnies, :logo_file_size, :integer
    add_column :compagnies, :logo_updated_at, :datetime
  end
end
