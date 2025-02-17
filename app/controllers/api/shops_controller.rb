class Api::ShopsController < ApplicationController
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user!
  before_action :set_shop, only: [:update, :destroy, :stock_summary]

    # ✅ Liste des shops de l'utilisateur
  def index
    shops = current_user.shops
    render json: shops, status: :ok
  end

# ✅ creation  shop de l'utilisateur
  def create
    shop = current_user.shops.create(shop_params)
    if shop.persisted?
      render json: shop, status: :created
    else
      render json: { errors: shop.errors.full_messages }, status: :unprocessable_entity
    end
  end


   # ✅ Mise à jour d'un shop
   def update
    if @shop.update(shop_params)
      render json: @shop, status: :ok
    else
      render json: { errors: @shop.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Suppression d'un shop
  def destroy
    @shop.destroy
    head :no_content
  end

 # ✅ Obtenir les stocks par catégorie
 def stock_summary
  # Récupérer les produits avec leur catégorie et leur stock
  products = @shop.products
                  .joins(:category)
                  .select('categories.id AS category_id, categories.name AS category_name, products.name AS product_name, products.stock')

  # Regrouper les produits par catégorie (avec l'ID de la catégorie)
  grouped_stock_summary = products.group_by { |p| { id: p.category_id, name: p.category_name } }
                                  .transform_values do |products|
    products.map { |p| { name: p.product_name, stock: p.stock } }
  end

  # Réorganiser les données pour un format plus structuré
  formatted_data = grouped_stock_summary.map do |category, products|
    {
      id: category[:id],
      name: category[:name],
      products: products
    }
  end

  render json: { stock_summary: { categories: formatted_data } }, status: :ok
end

  


  private

  def shop_params
    params.require(:shop).permit(:name, :location)
  end

  def set_shop
    @shop = current_user.shops.find_by(id: params[:id])
    render json: { error: "Shop not found" }, status: :not_found unless @shop
  end

end
