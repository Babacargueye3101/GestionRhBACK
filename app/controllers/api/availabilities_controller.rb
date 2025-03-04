class Api::AvailabilitiesController < ApplicationController
  skip_before_action :authenticate_user_token_token!, only: %i[index]
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user_token_token!, except: [:index] #Permet l'accès public à index Vérifie que c'est un admin connecté
  before_action :set_salon, only: [:create]
  #Contrôleur pour l'admin (création des disponibilités)

  def index
  shop_id = params[:shop_id]
  salon_id = params[:salon_id]

  # Vérifier si la boutique et le salon existent
  shop = Shop.find_by(id: shop_id)
  salon = shop&.salons&.find_by(id: salon_id)

  if shop.nil? || salon.nil?
    return render json: { error: "Boutique ou salon introuvable" }, status: :not_found
  end
    availabilities = salon.availabilities.left_joins(:reservations)
                                 .where(reservations: { id: nil }) # Exclut celles déjà réservées
                                 .order(:date).page(params[:page]).per(10)
    the_avaibilities = availabilities.map do |availability|
      {
        id: availability&.id,
        date: availability&.date,
        time_slots: availability&.time_slots,
        salon: {
          id: availability&.salon&.id,
          name: availability&.salon&.name
        },
        shop: {
          id: availability&.salon&.shop&.id,
          name: availability&.salon&.shop&.name
        }
      }
    end
    render json: the_avaibilities
  end

  def create
    availability = @salon.availabilities.new(availability_params)
    availability.user = current_user
    if availability.save
      render json: availability, status: :created
    else
      render json: { errors: availability.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    availability = current_user.availabilities.find_by(id: params[:id])
  
    if availability.nil?
      render json: { message: "Disponibilité non trouvée" }, status: :not_found
    else
      availability.destroy
      render json: { message: "Disponibilité supprimée" }, status: :ok
    end
  end

  private

  def set_salon
    @salon = Salon.find_by(id: params[:salon_id])
    render json: { error: "Salon introuvable" }, status: :not_found unless @salon
  end

  def availability_params
    params.require(:availability).permit(:date, time_slots: []).merge(salon_id: @salon.id)
  end
end
