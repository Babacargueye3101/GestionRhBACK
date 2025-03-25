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
        payement_type: params[:payment][:paymentType],
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
        # Initier le paiement Orange Money
        if params[:payment][:paymentMethod] == 'mobile' && params[:payment][:paymentType]&.downcase == 'orange_money'
          om_service = OrangeMoneyService.new
          payment_response = om_service.initiate_payment(
            params[:payment][:mobilePhone],
            order.total,
            SecureRandom.uuid, # Générer une référence unique
            params[:payment][:otp] # OTP fourni par l'utilisateur
          )

          if payment_response && payment_response["status"] == "SUCCESS"
            order.update(paid: true, status: 'paid')
          else
            return render json: { error: "Échec du paiement Orange Money" }, status: :unprocessable_entity
          end
        end

        render json: order, include: :order_items, status: :created
      else
        render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  private

  # Simuler un appel à l'API Wave pour effectuer le paiement
  def process_wave_payment(mobile_phone, amount)
    # Simuler une requête HTTP vers l'API Wave
    # Remplacez cette logique par un appel réel à l'API Wave si nécessaire
    if mobile_phone == "valid_number" # Simuler un numéro valide
      { success: true, token: "wave_payment_token" }
    else
      { success: false, message: "Numéro de téléphone invalide ou solde insuffisant" }
    end
  end
end
