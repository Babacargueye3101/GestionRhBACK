class Api::CategoriesController < ApplicationController
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user!
  before_action :set_shop
  before_action :set_category, only: [:update, :destroy]

  # ✅ Liste des catégories d'une boutique
  def index
    render json: @shop.categories, status: :ok
  end

  # ✅ Création d'une nouvelle catégorie
  def create
    category = @shop.categories.create(category_params)
    if category.persisted?
      render json: category, status: :created
    else
      render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
    end
  end

   # ✅ Mise à jour d'une catégorie
  def update
    if @category.update(category_params)
      render json: @category, status: :ok
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Suppression d'une catégorie
  def destroy
    @category.destroy
    head :no_content
  end

  private

  def set_shop
    @shop = current_user.shops.find_by(id: params[:shop_id])
    render json: { error: "Shop not found" }, status: :not_found unless @shop
  end

  def set_category
    @category = @shop.categories.find_by(id: params[:id])
    render json: { error: "Category not found" }, status: :not_found unless @category
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
