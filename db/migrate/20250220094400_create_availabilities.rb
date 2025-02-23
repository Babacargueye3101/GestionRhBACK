class CreateAvailabilities < ActiveRecord::Migration[7.1]
  def change
    create_table :availabilities do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date, null: false
      t.text :time_slots, array: true, default: [] # Stocke les créneaux disponibles sous forme de tableau

      t.timestamps
    end
  end
end
