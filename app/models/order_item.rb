# app/models/order_item.rb
class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  belongs_to :variant, optional: true
  validates :quantity, :price, presence: true

  before_save :set_variant_details
  
  private
  
  def set_variant_details
    return unless variant.present?
    
    self.variant_details = {
      name: variant.name
    }
  end
end