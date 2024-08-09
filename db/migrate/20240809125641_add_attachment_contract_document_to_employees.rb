class AddAttachmentContractDocumentToEmployees < ActiveRecord::Migration[6.1]
  def self.up
    change_table :employees do |t|
      t.attachment :contract_document
    end
  end

  def self.down
    remove_attachment :employees, :contract_document
  end
end
