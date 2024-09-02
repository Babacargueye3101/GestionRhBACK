class AddAttachmentContractDocumentToEmployees < ActiveRecord::Migration[6.1]
  def up
    add_column :employees, :contract_document_file_name, :string
    add_column :employees, :contract_document_content_type, :string
    add_column :employees, :contract_document_file_size, :integer
    add_column :employees, :contract_document_updated_at, :datetime
  end

  def down
    remove_column :employees, :contract_document_file_name
    remove_column :employees, :contract_document_content_type
    remove_column :employees, :contract_document_file_size
    remove_column :employees, :contract_document_updated_at
  end
end
