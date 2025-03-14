class Api::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy, :update_role]
  before_action :set_user, only: [:update_role, :update_password]

  def index
    @users = User.all
    render json: @users
  end

  def update_role
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # ✅ Méthode pour mettre à jour le mot de passe de l'utilisateur
  def update_password
    if @user.valid_password?(params[:current_password])
      if @user.update(password: params[:new_password])
        render json: { message: "Mot de passe mis à jour avec succès" }, status: :ok
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Mot de passe actuel incorrect" }, status: :unauthorized
    end
  end
  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :can_see_dashboard,
      :can_see_reservation,  # Renommé de can_see_candidature
      :can_see_vente,        # Renommé de can_see_formation
      :can_see_employee,
      :can_see_dispo,        # Renommé de can_see_paies
      :can_see_shop,         # Nouveau champ
      :can_see_client,       # Nouveau champ
      :can_see_configuration,# Nouveau champ
      :can_see_subs,
      :can_see_salon         # Nouveau champ
    )
  end
end