class Api::PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]


  def index
    @payments= Payment.page(params[:page]).per(params[:per_page] || 10)
                      .where(compagny_id: params[:compagny_id])
                      .order(updated_at: :DESC)
    render json: {
      payments: @payments.as_json(include: { employee: { only: [:id, :name] } })
    }
  end
  # GET /payments/:id
  def show
    render json: @payment
  end

  # POST /payments
  def create
    @payment = Payment.new(payment_params)
    if @payment.save
      render json: @payment, status: :created
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /payments/:id
  def update
    if @payment.update(payment_params)
      render json: @payment
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /payments/:id
  def destroy
    @payment.destroy
    head :no_content
  end

  private

  # Utilisé pour trouver le paiement correspondant aux méthodes :show, :update, :destroy
  def set_payment
    @payment = Payment.find(params[:id])
  end

  # Fort paramétrage, ne permet que les paramètres spécifiés
  def payment_params
    params.require(:payment).permit(:amount, :status, :employee_id, :payment_method, :reference_number, :payment_date, :compagny_id)
  end
end
