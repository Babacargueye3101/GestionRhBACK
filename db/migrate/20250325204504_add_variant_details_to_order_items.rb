class AddVariantDetailsToOrderItems < ActiveRecord::Migration[7.1]
  def change
    add_reference :order_items, :variant, foreign_key: true
    add_column :order_items, :variant_details, :jsonb, default: {}
  end
end
