class Api::PaymentMethodesController < ApplicationController
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user_token_token!
  before_action :set_payment_methode, only: [:show, :update, :destroy]

  # GET /api/payment_methodes
  def index
    @payment_methodes = PaymentMethode.all
    render json: @payment_methodes
  end

  # GET /api/payment_methodes/:id
  def show
    render json: @payment_methode
  end

  # POST /api/payment_methodes
  def create
    @payment_methode = PaymentMethode.new(payment_methode_params)
    if @payment_methode.save
      render json: @payment_methode, status: :created
    else
      render json: { errors: @payment_methode.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /api/payment_methodes/:id
  def update
    if @payment_methode.update(payment_methode_params)
      render json: @payment_methode
    else
      render json: { errors: @payment_methode.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/payment_methodes/:id
  def destroy
    @payment_methode.destroy
    head :no_content
  end

  private

  def set_payment_methode
    @payment_methode = PaymentMethode.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Payment Methode not found" }, status: :not_found
  end

  def payment_methode_params
    params.require(:payment_methode).permit(:name)
  end
end
