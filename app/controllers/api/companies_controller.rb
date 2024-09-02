class Api::CompaniesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy, :upload_logo]
  before_action :set_company, only: [:show, :update, :destroy]

  # GET /api/companies
  def index
    @companies = Compagny.all
    render json: @companies
  end

  # GET /api/companies/:id
  def show
    @entreprise= Compagny.find(params[:id])
    render json: {compagny: @compagny, currentCompagny: @entreprise}
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

  def upload_logo
    @company = Compagny.find(params[:id])
    if params[:logo_compagny].present?
      @company.logo.attach(params[:logo_compagny])
      if @company.save

        logo_url = url_for(@company.logo) # Obtient l'URL du fichier attaché
        Rails.logger.info "Creating a new employee with params: #{@company.inspect}"
        @company.update(url: logo_url)
        Rails.logger.info "URL : #{logo_url}"
        render json: { message: 'Document uploaded successfully', logo_url: logo_url }, status: :ok
      else
        render json: @company.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'No file provided' }, status: :bad_request
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_company
    @company = Compagny.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def company_params
    params.require(:compagny).permit(:name, :address, :city, :state, :countrie, :zipCode, :phoneNumber, :email, :website, :description, :logo)
  end
end
