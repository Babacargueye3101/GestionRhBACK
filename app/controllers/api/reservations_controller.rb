class Api::ReservationsController < ApplicationController
  skip_before_action :authenticate_user_token_token!, only: %i[create]
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user_token_token!, only: [:show, :update]
  before_action :set_reservation, only: [:show, :update]
  #Contrôleur pour les clients (prise de rendez-vous)
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

  def set_reservation
    @reservation = Reservation.find_by(id: params[:id])
    render json: { error: "Réservation non trouvée" }, status: :not_found unless @reservation
  end
end
