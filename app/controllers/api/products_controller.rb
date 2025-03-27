class Api::ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user_token_token!
  before_action :set_shop, except: [:pending_orders]
  before_action :set_product, only: [:update, :destroy, :show]

  # ✅ Liste des produits d'une boutique
  def index
    products = @shop.products.with_attached_image
  
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

  # ✅ Création d'un produit
  # def create
  #   product = @shop.products.new(product_params)

  #   if params[:image].present?
  #     product.image.attach(params[:image])  # 📸 Attache l'image si elle est présente
  #   end
  
  #   if product.save
  #     render json: product_with_image_url(product), status: :created
  #   else
  #     render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

    # ✅ Création d'un produit avec variantes
    def create
      product = @shop.products.new(product_params)
    
      product.image.attach(params[:image]) if params[:image].present?
    
      if product.save
        create_variants(product)  # ✅ Créer les variantes après avoir sauvegardé le produit
    
        render json: product_with_variants(product), status: :created
      else
        render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
      end
    end  
       

  # ✅ Mise à jour d'un produit
  def update
    if @product.update(product_params)
      # Gestion de l'image si un fichier est envoyé
      @product.image.attach(params[:image]) if params[:image].present?
  
      render json: {
        id: @product.id,
        name: @product.name,
        description: @product.description,
        price: @product.price,
        stock: @product.stock,
        category: {
          id: @product.category&.id,
          name: @product.category&.name
        },
        image_url: @product.image.attached? ? url_for(@product.image) : nil
      }, status: :ok
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Suppression d'un produit
  def destroy
    if @product
      @product.image.purge if @product.image.attached?  # Supprime l'image attachée
      @product.destroy
      render json: { message: "Produit supprimé avec succès" }, status: :ok
    else
      render json: { error: "Produit introuvable" }, status: :not_found
    end
  end 

    # ✅ Afficher un produit avec ses variantes
    def show
      render json: product_with_variants(@product), status: :ok
    end

    def pending_orders
      orders = Order.where(status: "pending")
                   .order(created_at: :desc)
                   .limit(10)
                   .includes(:order_items)

      data = {
        orders: orders,
        total: orders.count
      }
      render json: data, status: :ok
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
    params.permit(:name, :description, :price, :stock, :category_id, :image)
  end
  # ✅ Gestion des paramètres pour les variantes
  def variants_params
    return [] unless params[:variants].present?
    
    params[:variants].values.map do |variant|
      variant.permit(:name, :stock)
    end
  end  

  # ✅ Créer des variantes pour un produit
  def create_variants(product)
    variants_params.each_with_index do |variant_param, index|
      variant = product.variants.create(variant_param)
    end
  end
  

  # ✅ Mettre à jour les variantes d'un produit
  def update_variants(product)
    product.variants.destroy_all
    create_variants(product)
  end

  # ✅ Retourne un produit avec ses variantes
  def product_with_variants(product)
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
      variants: product.variants.map do |variant|
        {
          id: variant.id,
          name: variant.name,
          stock: variant.stock
        }
      end
    }
  end

  # def product_with_image_url(product)
  #   {
  #     id: product.id,
  #     name: product.name,
  #     description: product.description,
  #     price: product.price,
  #     stock: product.stock,
  #     image_url: product.image.attached? ? url_for(product.image) : nil  # 🔥 Génère l'URL de l'image
  #   }
  # end
end
