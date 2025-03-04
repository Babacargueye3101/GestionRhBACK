class Api::ReservationsController < ApplicationController
  skip_before_action :authenticate_user_token_token!, only: %i[create]
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user_token_token!, only: [:show, :update]
  before_action :set_reservation, only: [:show, :update]
  before_action :set_shop_and_salon, only: [:index]
  #Contrôleur pour les clients (prise de rendez-vous)
  
  def index
    availabilities = @salon.availabilities.includes(:reservations).order(:created_at).page(params[:page]).per(10)
    reservations = availabilities.flat_map(&:reservations) # Récupérer toutes les réservations des disponibilités du salon
    the_reservations = reservations.map do |reservation|
      {
        id: reservation.id,
        date: reservation.availability&.date,
        time: reservation.time,
        status: reservation.status,
        client: {
          id: reservation.client&.id,
          name: reservation.client&.name,
          prenom: reservation.client&.surname,
          email: reservation.client&.email,
          phone: reservation.client&.phone
        },
        salon: {
          id: reservation.availability&.salon&.id,
          name: reservation.availability&.salon&.name
        },
        shop: {
          id: reservation.availability&.salon&.shop&.id,
          name: reservation.availability&.salon&.shop&.name
        }
      }
    end
  
    render json: the_reservations
  end
  

  def create
    existing_client_by_email = Client.find_by(email: client_params[:email])
    existing_client_by_phone = Client.find_by(phone: client_params[:phone])
  
    if existing_client_by_email && existing_client_by_email.phone != client_params[:phone]
      return render json: { error: "Cet email est déjà utilisé avec un autre numéro de téléphone." }, status: :unprocessable_entity
    end
  
    if existing_client_by_phone && existing_client_by_phone.email != client_params[:email]
      return render json: { error: "Ce numéro de téléphone est déjà utilisé avec un autre email." }, status: :unprocessable_entity
    end
  
    client = existing_client_by_email || existing_client_by_phone || Client.create(client_params)
  
    unless client.persisted?
      return render json: { errors: client.errors.full_messages }, status: :unprocessable_entity
    end

    availability = Availability.find(params[:availability_id])

    if availability.time_slots.exclude?(params[:time])
      return render json: { error: "Créneau indisponible" }, status: :unprocessable_entity
    end

    reservation = client.reservations.new(availability: availability, time: params[:time])

    if reservation.save
      render json: reservation, status: :created
    else
      render json: { errors: reservation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    if @reservation.nil?
      render json: { message: "Reservation non trouvée" }, status: :not_found
    else
      data = {
        "reservation" => @reservation,
        "client" => @reservation.client
      }
      render json: data
    end
    
  end

  def update
    if  @reservation.update(status: params[:status])
      ReservationMailer.confirmation_email(current_user, @reservation).deliver_now # 🔥 Envoi de l'email
      render json: @reservation, status: :ok
    else
      render json: { errors: @reservation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def client_params
    params.require(:client).permit(:name, :surname, :email, :phone)
  end

  def set_shop_and_salon
    @shop = Shop.find_by(id: params[:shop_id])
    @salon = @shop&.salons&.find_by(id: params[:salon_id])
    if @shop.nil? || @salon.nil?
      render json: { error: "Boutique ou salon introuvable" }, status: :not_found
    end
  end

  def set_reservation
    @reservation = Reservation.find_by(id: params[:id])
    render json: { error: "Réservation non trouvée" }, status: :not_found unless @reservation
  end
end
