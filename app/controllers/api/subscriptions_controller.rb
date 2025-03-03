class Api::SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:show, :destroy]
  skip_before_action :authenticate_user_token_token!, only: %i[index]
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user_token_token!, only: [:update, :update, :destroy]

  def index
    subscriptions = Subscription.includes(:client).all
    data = subscriptions.map do |subscription|
      {
        id: subscription.id,
        client: {
          id: subscription.client.id,
          name: subscription.client.name,
          email: subscription.client.email
        },
        subscription_type: subscription.subscription_type.name,
        subscription_card_number: subscription.card_number,
        active: subscription.active,
        created_at: subscription.created_at,
        updated_at: subscription.updated_at
      }
    end
    render json: data, status: :ok
  end

  def create
    subscription = Subscription.new(subscription_params)
    if subscription.save
      render json: subscription, status: :created
    else
      render json: { errors: subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @subscription.update(active: params[:active])
      render json: @subscription
    else
      render json: { errors: @subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @subscription.update(active: false)
    render json: { message: "Abonnement désactivé" }
  end

  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.require(:subscription).permit(:client_id, :subscription_type_id)
  end

end
