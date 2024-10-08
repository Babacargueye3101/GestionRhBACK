class Api::V1::AppointmentsController < ApplicationController

  before_action :set_appointment, only: [:show, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]


  # GET /api/v1/appointments
  def index
    @appointments = Appointment.where(compagny_id: params[:compagny_id])
                           .order(updated_at: :desc)
                           .page(params[:page])
                           .per(params[:per_page] || 10)

    # Ajoutez le nombre total de rendez-vous (sans pagination)
    total_count = Appointment.where(compagny_id: params[:compagny_id]).count

    render json: {
      appointments: @appointments,
      total_count: total_count
    }

  end

  # GET /api/v1/appointments/:id
  def show
    render json: @appointment
  end

  # POST /api/v1/appointments
  def create
    @appointment = Appointment.new(appointment_params)
    if @appointment.save
      render json: @appointment, status: :created
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/appointments/:id
  def update
    if @appointment.update(appointment_params)
      render json: @appointment
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/appointments/:id
  def destroy
    @appointment.destroy
    head :no_content
  end

  private

  # Set the appointment for the show, update, and destroy actions
  def set_appointment
    @appointment = Appointment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Appointment not found' }, status: :not_found
  end

  # Permet les paramètres autorisés pour les rendez-vous
  def appointment_params
    params.require(:appointment).permit(
      :start_time,
      :end_time,
      :location,
      :description,
      :status,
      :appointment_type,
      :compagny_id
    )
  end

end
