class Api::HomeController < ApplicationController
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user_token_token!, except: [:products_by_category, :all_products, :all_categories, :all_shops, :salons_by_shop, :create_order]
    
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

  # ✅ Créer une commande
  def create_order
    ActiveRecord::Base.transaction do
      order = Order.new(
        client_name: params[:client][:name],
        client_phone: params[:client][:phone],
        client_address: params[:client][:address],
        total: params[:total].delete('$').to_f,
        payment_method: params[:payment][:paymentMethod],
        mobile_phone: params[:payment][:mobilePhone],
        status: 'pending'
      )

      if order.save
        params[:products].each do |product_params|
          product = Product.find(product_params[:id])
          order.order_items.create!(
            product: product,
            quantity: 1, # Vous pouvez ajuster la quantité selon vos besoins
            price: product_params[:price].to_f
          )
        end
        render json: order, include: :order_items, status: :created
      else
        render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
