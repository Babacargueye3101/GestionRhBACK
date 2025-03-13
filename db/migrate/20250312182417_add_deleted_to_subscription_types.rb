class AddDeletedToSubscriptionTypes < ActiveRecord::Migration[7.1]
  def change
    add_column :subscription_types, :deleted, :boolean, default: false
  end
end
