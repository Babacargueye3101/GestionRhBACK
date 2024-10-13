class AddAttachmentFileToDocuments < ActiveRecord::Migration[7.2]
  def change
    add_column :documents, :file_file_name, :string
    add_column :documents, :file_content_type, :string
    add_column :documents, :file_file_size, :integer
    add_column :documents, :file_updated_at, :datetime
  end
end
