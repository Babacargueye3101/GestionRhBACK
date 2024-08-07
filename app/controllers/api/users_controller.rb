class Api::UsersController <  ApplicationController

  def get_user
     user=User.find(params[:id]);
  end
end
