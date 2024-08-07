class Api::CompaniesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]
  before_action :set_company, only: [:show, :update, :destroy]

  # GET /api/companies
  def index
    @companies = Compagny.all
    render json: @companies
  end

  # GET /api/companies/:id
  def show
    render json: @compagny
  end

  # POST /api/companies
  def create
    @company = Compagny.new(company_params)

    if @company.save
      render json: @compagny, status: :created
    else
      render json: @compagny.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/companies/:id
  def update
    if @company.update(company_params)
      render json: @compagny
    else
      render json: @compagny.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/companies/:id
  def destroy
    @compagny.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_company
    @company = Compagny.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def company_params
    params.require(:compagny).permit(:name, :address, :city, :state, :countrie, :zipCode, :phoneNumber, :email, :website, :description)
  end
end
