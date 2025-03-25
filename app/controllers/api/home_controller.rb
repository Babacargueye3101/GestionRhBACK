class Api::HomeController < ApplicationController
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user_token_token!, except: [:products_by_category, :all_products, :all_categories, :all_shops, :salons_by_shop, :create_order]
    
  # ✅ Version mise à jour de products_by_category avec variantes
  def products_by_category
    category = Category.find_by(id: params[:id])
    return render json: { error: "Category not found" }, status: :not_found unless category

    products = category.products.includes(:shop, :variants, image_attachment: :blob)
    
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
        image_url: product.image.attached? ? url_for(product.image) : nil,
        variants: product.variants.load.map do |variant|
          {
            id: variant.id,
            name: variant.name,
            stock: variant.stock
          }
        end
      }
    end

    render json: the_products, status: :ok
  end

  # ✅ Version mise à jour de all_products avec variantes
  def all_products
    products = Product.includes(:shop, :category, :variants, image_attachment: :blob).all
    
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
        image_url: product.image.attached? ? url_for(product.image) : nil,
        variants:  product.variants.load.map do |variant|
          {
            id: variant.id,
            name: variant.name,
            stock: variant.stock
          }
        end
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

  def create_order
    ActiveRecord::Base.transaction do
      # Création de la commande
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
          if product_params[:variant_id].present?
            # Cas où le client a choisi une variante spécifique
            variant = Variant.find(product_params[:variant_id])
            
            # Vérification du stock de la variante
            if variant.stock < product_params[:quantity].to_i
              raise ActiveRecord::Rollback, "Stock insuffisant pour la variante #{variant.name}"
            end
            
            # Création de l'item de commande avec la variante
            order.order_items.create!(
              product: variant.product,
              variant: variant,
              quantity: product_params[:quantity].to_i,
              price: product_params[:price].to_f,
              variant_details: variant.name # Stocker les infos de la variante
            )
            
            # Mise à jour du stock de la variante
            variant.update!(stock: variant.stock - product_params[:quantity].to_i)
            
            # Mise à jour du stock général du produit si nécessaire
            # (selon votre logique métier)
            variant.product.update!(stock: variant.product.stock - product_params[:quantity].to_i)
          else
            # Cas où le client a choisi le produit sans variante spécifique
            product = Product.find(product_params[:id])
            
            # Vérification du stock du produit
            if product.stock < product_params[:quantity].to_i
              raise ActiveRecord::Rollback, "Stock insuffisant pour le produit #{product.name}"
            end
            
            # Création de l'item de commande sans variante
            order.order_items.create!(
              product: product,
              quantity: product_params[:quantity].to_i,
              price: product_params[:price].to_f
            )
            
            # Mise à jour du stock du produit
            product.update!(stock: product.stock - product_params[:quantity].to_i)
          end
        end
  
        # Paiement Orange Money (garder votre logique existante)
        unless params[:payment][:paymentMethod] == 'mobile' && params[:payment][:paymentType]&.downcase == 'orange_money'
          om_service = OrangeMoneyService.new
          payment_response = om_service.initiate_payment(
            params[:payment][:mobilePhone],
            order.total,
            SecureRandom.uuid,
            params[:payment][:otp]
          )
  
          if payment_response && payment_response["status"] == "SUCCESS"
            order.update!(paid: true, status: 'paid')
          else
            raise ActiveRecord::Rollback, "Échec du paiement Orange Money"
          end
        end
  
        render json: order, include: { order_items: { include: [:product, :variant] } }, status: :created
      else
        render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::Rollback => e
      render json: { error: e.message }, status: :unprocessable_entity
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
