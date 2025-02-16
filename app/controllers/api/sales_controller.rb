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

  # ✅ Créer une vente
  def create
    sale = @shop.sales.new(sale_params)
    sale.user = current_user

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
    params.require(:sale).permit(:buyer_name, :buyer_surname, :channel, :total_price, :paid_amount, :payment_method, :delivered, :sale_date)
  end
end
