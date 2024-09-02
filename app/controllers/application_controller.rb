class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :set_csrf_headers
  before_action :set_default_url_options

  private

  def set_csrf_headers
    response.set_header('X-CSRF-Token', form_authenticity_token)
  end

  def set_default_url_options
    Rails.application.routes.default_url_options[:host] = 'gestionrhback.onrender.com'
  end
end
