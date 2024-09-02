class CreateDocuments < ActiveRecord::Migration[7.2]
  def change
    create_table :documents do |t|
      t.string :title
      t.references :folder, null: false, foreign_key: true

      t.timestamps
    end
  end
end
