class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :set_csrf_headers

  private

  def set_csrf_headers
    response.set_header('X-CSRF-Token', form_authenticity_token)
  end
end
