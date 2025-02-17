class Api::SalesController < ApplicationController
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user!
  before_action :set_shop
  before_action :set_sale, only: [:show, :update, :destroy]

  # ✅ Lister les ventes d'une boutique
  def index
    sales = @shop.sales.includes(:user, :payments, :sale_items)
    render json: sales, status: :ok
  end
      # ✅ Voir les details de ventes d'une boutique
  def show
    sale = @shop.sales.includes(:sale_items).find(params[:id])
  
    sale_data = {
      id: sale.id,
      buyer_name: sale.buyer_name,
      buyer_surname: sale.buyer_surname,
      channel: sale.channel,
      total_price: sale.total_price,
      paid_amount: sale.paid_amount,
      payment_method: sale.payment_method,
      delivered: sale.delivered,
      sale_date: sale.sale_date,
      sale_items: sale.sale_items.map do |item|
        {
          product_id: item.product_id,
          product_name: item.product.name,
          quantity: item.quantity,
          price: item.price,
          subtotal: item.quantity * item.price
        }
      end
    }
  
    render json: { sale: sale_data }, status: :ok
  end
  # ✅ Créer une vente
  def create
    sale = @shop.sales.new(sale_params)
    sale.user = current_user
  # Calculer total_price en fonction des produits
    total_price = 0

    params[:products].each do |product|
      total_price += product[:quantity] * product[:price]
    end

    sale.total_price = total_price # Mettre à jour le total_price calculé

    if sale.save
      params[:products].each do |product|
        sale.sale_items.create(product_id: product[:id], quantity: product[:quantity], price: product[:price])
      end
      render json: sale, status: :created
    else
      render json: { errors: sale.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Mise à jour d'une vente
  def update
    if @sale.update(sale_params)
      render json: @sale, status: :ok
    else
      render json: { errors: @sale.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Suppression d'une vente
  def destroy
    @sale.destroy
    head :no_content
  end

  private

  def set_shop
    @shop = current_user.shops.find_by(id: params[:shop_id])
    render json: { error: "Shop not found" }, status: :not_found unless @shop
  end

  def set_sale
    @sale = @shop.sales.find_by(id: params[:id])
    render json: { error: "Sale not found" }, status: :not_found unless @sale
  end

  def sale_params
    params.require(:sale).permit(:buyer_name, :buyer_surname, :channel, :paid_amount, :payment_method, :delivered, :sale_date)
  end
end
