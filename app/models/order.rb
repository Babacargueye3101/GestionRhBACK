# app/models/order.rb
class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  validates :client_name, :client_phone, :client_address, :total, :payment_method, presence: true
end