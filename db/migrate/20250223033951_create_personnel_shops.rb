class CreatePersonnelShops < ActiveRecord::Migration[7.1]
  def change
    create_table :personnel_shops do |t|
      t.references :personnel, null: false, foreign_key: true
      t.references :shop, null: true, foreign_key: true  # Boutique
      t.references :salon, null: true, foreign_key: true # Salon

      t.boolean :can_view_stats, default: false # Permission pour voir les stats

      t.timestamps
    end
  end
end
