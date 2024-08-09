# app/controllers/api/registrations_controller.rb
class Api::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token, only: [:create]
  respond_to :json

  def create
    user = User.new(user_params)
    if user.save
      render json: { message: 'Utilisateur créé avec succès' }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :name, :compagny_id)
  end
end
