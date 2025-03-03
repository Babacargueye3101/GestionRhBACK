class Api::ServicesController < ApplicationController
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user_token_token!
  before_action :set_salon
  before_action :set_service, only: %i[show update destroy]

  # ✅ Liste des services d'un salon
  def index
    services = @salon.services.page(params[:page]).per(10)
    render json: services, status: :ok
  end

  # ✅ Afficher un service spécifique
  def show
    render json: @service, status: :ok
  end

  # ✅ Créer un service dans un salon
  def create
    service = @salon.services.new(service_params)

    if service.save
      render json: service, status: :created
    else
      render json: { errors: service.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Mettre à jour un service
  def update
    if @service.update(service_params)
      render json: @service, status: :ok
    else
      render json: { errors: @service.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Supprimer un service
  def destroy
    @service.destroy
    head :no_content
  end

  private

  def set_salon
    @salon = Salon.find_by(id: params[:salon_id])
    render json: { error: "Salon not found" }, status: :not_found unless @salon
  end

  def set_service
    @service = @salon.services.find_by(id: params[:id])
    render json: { error: "Service not found" }, status: :not_found unless @service
  end

  def service_params
    params.require(:service).permit(:name, :description, :price, :duration)
  end
end
