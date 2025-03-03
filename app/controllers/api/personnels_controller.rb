class Api::PersonnelsController < ApplicationController
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user_token_token!
  before_action :set_personnel, only: [:show, :update, :destroy]
  
  # Récupérer la liste des employés
  def index
    personnels = Personnel.includes(:shops, :salons).all.page(params[:page]).per(10)
    render json: personnels, include: [:shops, :salons]
  end

  # Créer un personnel et l'affecter à un ou plusieurs salons/shops
  def create
    ActiveRecord::Base.transaction do  # 🔥 Assure que tout se fait ou rien du tout
      user = User.new(
        email: personnel_params[:email],
        password: SecureRandom.hex(8), # 🔥 Génère un mot de passe aléatoire
        name: "#{personnel_params[:first_name]} #{personnel_params[:last_name]}",
        compagny_id: 1
      )
  
      if user.save
        
        personnel = user.create_personnel(personnel_params)  # Associe le personnel au user
        UserMailer.welcome_email(user, user.password).deliver_later
  
        if personnel.persisted?
          render json: { message: 'Personnel et compte utilisateur créés', personnel: personnel, user: user }, status: :created
        else
          render json: { errors: personnel.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  # Voir un employé spécifique
  def show
    render json: @personnel, include: [:shops, :salons]
  end

  # Modifier un personnel
  def update
    if @personnel.update(personnel_params)
      assign_shops_and_salons(@personnel)
      render json: @personnel
    else
      render json: { errors: @personnel.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Supprimer un personnel
  def destroy
    @personnel.destroy
    render json: { message: "Personnel supprimé" }, status: :ok
  end

  private

  def set_personnel
    @personnel = Personnel.find_by(id: params[:id])
    render json: { error: "Personnel introuvable" }, status: :not_found unless @personnel
  end

  def personnel_params
    params.require(:personnel).permit(:first_name, :last_name, :address, :phone, :email, :can_view_statistics)
  end

  # Assigner les shops et salons
  def assign_shops_and_salons(personnel)
    personnel.personnel_shops.destroy_all  # Supprime les anciennes affectations
    
    (params[:shop_ids] || []).each do |shop_id|
      personnel.personnel_shops.create(shop_id: shop_id)
    end
    
    (params[:salon_ids] || []).each do |salon_id|
      personnel.personnel_shops.create(salon_id: salon_id)
    end
  end
end
