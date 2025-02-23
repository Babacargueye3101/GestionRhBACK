class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.references :client, null: false, foreign_key: true
      t.references :availability, null: false, foreign_key: true
      t.string :time
      t.string :status, default: "pending" # Ajoutez la valeur par défaut ici

      t.timestamps
    end
  end
end
