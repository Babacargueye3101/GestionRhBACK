class CreateAppointments < ActiveRecord::Migration[6.1]
  def change
    create_table :appointments do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :location
      t.text :description
      t.integer :status

      t.timestamps
    end
  end
end
