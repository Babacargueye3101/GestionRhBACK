class Api::HomeController < ApplicationController
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user_token_token!, except: [:products_by_category, :all_products, :all_categories, :all_shops, :salons_by_shop]
    
  # ✅ Récupérer les produits par catégorie
  def products_by_category
    category = Category.find_by(id: params[:id])
    if category.nil?
      render json: { error: "Category not found" }, status: :not_found
      return
    end

    products = category.products.with_attached_image.page(params[:page]).per(10)
    the_products = products.map do |product|
      {
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        stock: product.stock,
        category: {
          id: product.category&.id,
          name: product.category&.name
        },
        image_url: product.image.attached? ? url_for(product.image) : nil
      }
    end

    render json: the_products, status: :ok
  end 

  # ✅ Lister tous les produits de toutes les boutiques
  def all_products
    products = Product.includes(:shop, :category, image_attachment: :blob).all
    the_products = products.map do |product|
      {
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        stock: product.stock,
        shop: {
          id: product.shop.id,
          name: product.shop.name
        },
        category: {
          id: product.category&.id,
          name: product.category&.name
        },
        image_url: product.image.attached? ? url_for(product.image) : nil
      }
    end

    render json: the_products, status: :ok
  end

  def all_categories
    categories = Category.all
    render json: categories, status: :ok
  end

  # ✅ Lister toutes les boutiques
  def all_shops
    shops = Shop.all
    render json: shops, status: :ok
  end

  # ✅ Récupérer les salons liés à une boutique
  def salons_by_shop
    shop = Shop.find_by(id: params[:shop_id])
    if shop.nil?
      render json: { error: "Shop not found" }, status: :not_found
      return
    end

    salons = shop.salons
    render json: salons, status: :ok
  end
end
