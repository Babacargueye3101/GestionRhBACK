class Api::SalonsController < ApplicationController
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user_token_token!
  before_action :set_shop
  before_action :set_salon, only: %i[show update destroy]

  # ✅ Liste des salons d'un shop
  def index
    salons = @shop.salons.page(params[:page]).per(10)
    render json: salons, status: :ok
  end

  # ✅ Afficher un salon spécifique
  def show
    render json: @salon, status: :ok
  end

  # ✅ Créer un salon dans un shop
  def create
    salon = @shop.salons.new(salon_params)

    if salon.save
      render json: salon, status: :created
    else
      render json: { errors: salon.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Mettre à jour un salon
  def update
    if @salon.update(salon_params)
      render json: @salon, status: :ok
    else
      render json: { errors: @salon.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Supprimer un salon
  def destroy
    @salon.destroy
    head :no_content
  end

  private

  def set_shop
    @shop = current_user.shops.find_by(id: params[:shop_id])
    render json: { error: "Shop not found" }, status: :not_found unless @shop
  end

  def set_salon
    @salon = @shop.salons.find_by(id: params[:id])
    render json: { error: "Salon not found" }, status: :not_found unless @salon
  end

  def salon_params
    params.require(:salon).permit(:name, :address, :phone, :description)
  end
end
