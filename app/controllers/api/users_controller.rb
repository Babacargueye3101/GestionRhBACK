class Api::UsersController <  ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy, :update_role]

  before_action :set_user, only: [:update_role]



  def index
    @users = User.all.page(params[:page]).per(10)
    render json: @users
  end

  def update_role
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:can_see_dashboard, :can_see_candidature, :can_see_formation, :can_see_employee, :can_see_paies)
  end
end
