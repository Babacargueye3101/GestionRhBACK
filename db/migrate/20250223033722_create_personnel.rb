class CreatePersonnel < ActiveRecord::Migration[7.1]
  def change
    create_table :personnels do |t|
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :phone
      t.string :email
      t.boolean :can_view_statistics, default: false
      t.timestamps
    end
  end
end
