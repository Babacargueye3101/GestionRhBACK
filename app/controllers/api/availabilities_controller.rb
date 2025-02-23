class Api::AvailabilitiesController < ApplicationController
  skip_before_action :authenticate_user, only: %i[index]
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user!, except: [:index] #Permet l'accès public à index Vérifie que c'est un admin connecté
  before_action :set_salon, only: [:create]
  #Contrôleur pour l'admin (création des disponibilités)

  def index
    availabilities = Availability.left_joins(:reservations)
                                 .where(reservations: { id: nil }) # Exclut celles déjà réservées
                                 .order(:date)
    render json: availabilities
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
