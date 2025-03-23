# app/controllers/api/time_slots_controller.rb
class Api::TimeSlotsController < ApplicationController
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user_token_token!
  # ✅ Fournir tous les horaires disponibles
  def index
    time_slots = TimeSlot.all.order(:start_time)
    formatted_time_slots = time_slots.map do |time_slot|
      {
        id: time_slot.id,
        time_range: "#{time_slot.start_time}-#{time_slot.end_time}" # Concatène start_time et end_time
      }
    end
    render json: formatted_time_slots, status: :ok
  end

  # ✅ Créer un nouvel horaire
  def create
    time_slot = TimeSlot.new(time_slot_params)
    if time_slot.save
      render json: time_slot, status: :created
    else
      render json: { errors: time_slot.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def time_slot_params
    params.require(:time_slot).permit(:start_time, :end_time)
  end
end