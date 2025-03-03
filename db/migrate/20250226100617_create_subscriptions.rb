class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.string :card_number
      t.references :subscription_type, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
