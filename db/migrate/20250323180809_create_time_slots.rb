# db/migrate/xxxxxx_create_time_slots.rb
class CreateTimeSlots < ActiveRecord::Migration[7.1]
  def change
    create_table :time_slots do |t|
      t.string :start_time, null: false
      t.string :end_time, null: false

      t.timestamps
    end
  end
end