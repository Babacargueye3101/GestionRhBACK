class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :authenticate_user_token_token!, except: [:register, :create]

  private

  def authenticate_user_token_token!
    token = request.headers['Authorization']&.split(' ')&.last
    begin
      decoded_token = JWT.decode(token, ENV['SECRET_KEY_BASE'])[0]
      @current_user = User.find(decoded_token['id'])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end