# # app/controllers/users/sessions_controller.rb
# module Users
#   class SessionsController < Devise::SessionsController

#     # POST /resource/sign_in
#     def create
#       self.resource = warden.authenticate!(auth_options)
#       set_flash_message!(:notice, :signed_in)
#       sign_in(resource_name, resource)
#       yield resource if block_given?
#       respond_with resource, location: after_sign_in_path_for(resource)
#     rescue StandardError => e
#       flash[:alert] = "Invalid email or password."
#       redirect_to new_user_session_path
#     end

#   end
# end

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: resource
  end

  def respond_to_on_destroy
    head :no_content
  end
end
