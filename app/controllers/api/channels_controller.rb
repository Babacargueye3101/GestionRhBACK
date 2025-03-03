class Api::ChannelsController < ApplicationController
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user_token_token!
  before_action :set_channel, only: [:show, :update, :destroy]

  # GET /api/channels
  def index
    @channels = Channel.all
    render json: @channels
  end

  # GET /api/channels/:id
  def show
    render json: @channel
  end

  # POST /api/channels
  def create
    @channel = Channel.new(channel_params)
    if @channel.save
      render json: @channel, status: :created
    else
      render json: { errors: @channel.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /api/channels/:id
  def update
    if @channel.update(channel_params)
      render json: @channel
    else
      render json: { errors: @channel.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/channels/:id
  def destroy
    @channel.destroy
    head :no_content
  end

  private

  def set_channel
    @channel = Channel.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Channel not found" }, status: :not_found
  end

  def channel_params
    params.require(:channel).permit(:name)
  end
end
