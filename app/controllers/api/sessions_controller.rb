class Api::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy, :register]
  respond_to :json

  def create
    user = User.find_for_database_authentication(email: params[:email])
    if user&.valid_password?(params[:password])
      sign_in user
      render json: { message: 'Login successful', user: user }, status: :ok
    else
      render json: { message: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    sign_out current_user
    render json: { message: 'Logout successful' }, status: :ok
  end

  def register
    user = User.new(user_params)
    if user.save
      render json: { message: 'Registration successful', user: user }, status: :created
    else
      render json: { message: 'Registration failed', errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :organismName)
  end
end
