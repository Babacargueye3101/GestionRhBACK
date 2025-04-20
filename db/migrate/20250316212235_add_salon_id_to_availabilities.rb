class AddSalonIdToAvailabilities < ActiveRecord::Migration[7.2]
  def change
    add_column :availabilities, :salon_id, :integer
    add_index :availabilities, :salon_id
  end
end
