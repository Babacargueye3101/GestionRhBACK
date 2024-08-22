# app/controllers/api/announcements_controller.rb
module Api
  class AnnouncementsController < ApplicationController
    before_action :set_announcement, only: [:show, :update, :destroy]
    skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]


    # GET /api/announcements
    def index
      @announcements = Announcement.all
      render json: @announcements
    end

    # GET /api/announcements/:id
    def show
      render json: @announcement
    end

    # POST /api/announcements
    def create
      @announcement = Announcement.new(announcement_params)
      if @announcement.save
        render json: @announcement, status: :created, location: api_announcement_url(@announcement)
      else
        render json: @announcement.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/announcements/:id
    def update
      ap "##############"
      ap announcement_params
      if @announcement.update(announcement_params)
        render json: @announcement
      else
        render json: @announcement.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/announcements/:id
    def destroy
      @announcement.destroy
      head :no_content
    end

    private

    # Set the announcement object for the actions
    def set_announcement
      @announcement = Announcement.find(params[:id])
    end

    # Strong parameters
    def announcement_params
      params.require(:announcement).permit(:title, :description, :date, :announcement_type, :start_date, :end_date, :user_id, :compagny_id)
    end
  end
end
