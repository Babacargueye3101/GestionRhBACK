# config/initializers/jwt.rb
JWT_SECRET_KEY = Rails.application.secrets.jwt_secret_key || 'your_secret_key_here'
