class AddAttachmentLogoToCompagnies < ActiveRecord::Migration[6.1]
  def self.up
    change_table :compagnies do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :compagnies, :logo
  end
end
