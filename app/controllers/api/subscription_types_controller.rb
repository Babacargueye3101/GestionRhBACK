class Api::SubscriptionTypesController < ApplicationController
  before_action :set_subscription_type, only: [:update, :destroy]
  skip_before_action :authenticate_user_token_token!, only: %i[subsrciption_by_client index]
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user_token_token!, only: [:update, :create, :destroy]
  def index
    subscription_types = SubscriptionType.all
    render json: subscription_types.map { |s| subscription_type_json(s) }, status: :ok
  end

  def create
    subscription_type = SubscriptionType.new(subscription_type_params)

    if params[:image].present?
      subscription_type.image.attach(params[:image])
    end

    if subscription_type.save
      render json: subscription_type_json(subscription_type), status: :created
    else
      render json: { errors: subscription_type.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @subscription_type.update(subscription_type_params)
      if params[:image].present?
        @subscription_type.image.purge
        @subscription_type.image.attach(params[:image])
      end
      render json: subscription_type_json(@subscription_type)
    else
      render json: { errors: @subscription_type.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @subscription_type.update(deleted: true)
    render json: { message: "Type d'abonnement désactivé" }
  end

  def subsrciption_by_client
    existing_client_by_email = Client.find_by(email: client_params[:email])
    existing_client_by_phone = Client.find_by(phone: client_params[:phone])
  
    if existing_client_by_email || existing_client_by_email&.phone
      client = existing_client_by_email || existing_client_by_phone
    else
      client = Client.create(client_params)
    end
  
    unless client.present?
      return render json: { error: "Client indisponible" }, status: :unprocessable_entity
    end

    subscription = Subscription.new(client_id: client&.id, subscription_type_id: params[:id])
    if subscription.save
      render json: subscription, status: :created
    else
      render json: { errors: subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_subscription_type
    @subscription_type = SubscriptionType.find(params[:id])
  end

  def subscription_type_params
    params.permit(:name, :price, :description, :letter, :active)
  end


  def client_params
    params.require(:client).permit(:name, :surname, :email, :phone)
  end

  def subscription_type_json(s)
    {
      id: s.id,
      name: s.name,
      price: s.price,
      description: s.description,
      letter: s.letter,
      active: s.active,
      image_url: s.image.attached? ? url_for(s.image) : nil
    }
  end
end
