# app/controllers/api/orders_controller.rb
class Api::OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user_token_token!

  def index
    orders = Order.all
    render json: orders, include: :order_items, status: :ok
  end

  def show
    order = Order.find(params[:id])
    order_details = {
      id: order.id,
      client_name: order.client_name,
      client_phone: order.client_phone,
      client_address: order.client_address,
      total: order.total,
      status: order.status,
      paid: order.paid,
      payment_method: order.payment_method,
      mobile_phone: order.mobile_phone,
      order_items: order.order_items.map do |item|
        {
          id: item.id,
          quantity: item.quantity,
          price: item.price,
          product: {
            id: item.product.id,
            name: item.product.name,
            description: item.product.description,
            price: item.product.price,
            stock: item.product.stock,
            shop: {
              id: item.product.shop.id,
              name: item.product.shop.name
            },
            category: {
              id: item.product.category&.id,
              name: item.product.category&.name
            },
            image_url: item.product.image.attached? ? url_for(item.product.image) : nil
          }
        }
      end
    }
    render json: order_details, status: :ok
  end

  def update_status
    order = Order.find(params[:id])
    if order.update(status: params[:status])
      if params[:status] == 'delivered'
        order.order_items.each do |item|
          product = item.product
          product.update(stock: product.stock - item.quantity)
        end
        # Marquer la commande comme payée si mobile_phone est vide
        if order.mobile_phone.blank?
          order.update(paid: true)
        end
      end
      render json: { message: "Order status updated successfully" }, status: :ok
    else
      render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    order = Order.find(params[:id])
    order.destroy
    render json: { message: "Order deleted" }, status: :ok
  end

end