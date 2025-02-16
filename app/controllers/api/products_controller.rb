class Api::ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user!
  before_action :set_shop
  before_action :set_product, only: [:update, :destroy]

  # ✅ Liste des produits d'une boutique
  def index
    products = @shop.products
    render json: products, status: :ok
  end

  # ✅ Création d'un produit
  def create
    product = @shop.products.create(product_params)
    if product.persisted?
      render json: product, status: :created
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Mise à jour d'un produit
  def update
    if @product.update(product_params)
      render json: @product, status: :ok
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Suppression d'un produit
  def destroy
    @product.destroy
    head :no_content
  end

  private

  def set_shop
    @shop = current_user.shops.find_by(id: params[:shop_id])
    render json: { error: "Shop not found" }, status: :not_found unless @shop
  end

  def set_product
    @product = @shop.products.find_by(id: params[:id])
    render json: { error: "Product not found" }, status: :not_found unless @product
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :category_id)
  end
end
