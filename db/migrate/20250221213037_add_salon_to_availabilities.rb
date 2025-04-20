class AddSalonToAvailabilities < ActiveRecord::Migration[7.1]
  def change
    add_reference :availabilities, :salon, null: false, foreign_key: true
  end
end
