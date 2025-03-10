class Api::ClientsController < ApplicationController
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user_token_token!
  before_action :set_client, only: [:show, :update, :destroy, :reservations]

  def index
    clients = Client.active
    render json: clients, status: :ok
  end

  def show
    if @client.nil?
      render json: { error: "Client not found" }, status: :not_found
      return
    end

    render json: @client, status: :ok
  end

  def create
    client = Client.new(client_params)
    if client.save
      render json: client, status: :created
    else
      render json: { error: client.errors.full_messages }, status: :bad_request
    end
  end

  def update
    if @client.nil?
      render json: { error: "Client not found" }, status: :not_found
      return
    end
    @client.update(client_params)
    render json: @client, status: :ok
  end

  # ✅ Suppression d'un client (suppression logique)
  def destroy
    if @client.soft_delete
      render json: { message: "Client marqué comme supprimé" }, status: :ok
    else
      render json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Récupérer les réservations d'un client avec les disponibilités correspondantes
  def reservations
    reservations = @client.reservations.includes(:availability)
    the_reservations = reservations.map do |reservation|
      {
        id: reservation.id,
        time: reservation.time,
        status: reservation.status,
        availability: {
          id: reservation.availability.id,
          date: reservation.availability.date,
          time_slots: reservation.availability.time_slots
        }
      }
    end
    render json: the_reservations, status: :ok
  end

  private

  def client_params
    params.require(:client).permit(:name, :surname, :email, :phone)
  end
  
  def set_client
    @client = Client.find(params[:id])
  end

end
