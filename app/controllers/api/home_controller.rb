class Api::HomeController < ApplicationController
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user_token_token!, except: [:products_by_category, :all_products]
    
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
end
