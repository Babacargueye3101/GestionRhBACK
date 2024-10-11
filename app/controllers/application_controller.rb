class ApplicationController < ActionController::Base

  before_action :authenticate_user, except: [:register, :create]

  private

  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    begin
      decoded_token = JWT.decode(token, ENV['SECRET_KEY_BASE'])[0]
      @current_user = User.find(decoded_token['id'])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
