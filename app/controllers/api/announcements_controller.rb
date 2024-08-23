# app/controllers/api/announcements_controller.rb
require 'csv'

require 'prawn'
require 'prawn/table'

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

      respond_to do |format|
        format.json { render json: @announcement }
        format.pdf do
          pdf = generate_single_annonce_pdf(@announcement)
          send_data pdf.render, filename: "facture-#{@announcement.id}-#{Date.today}.pdf", type: 'application/pdf'
        end
      end
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


    def generate_single_annonce_pdf(annonce)
      ap "##################"
      ap annonce
      ap "ZZZZZZZZZZZZZZZZZ"
      ap params
      compagny = Announcement.find(params[:id])&.compagny

      Prawn::Document.new(page_size: 'A4', page_layout: :portrait) do
        # Définir les dimensions de la ligne d'en-tête
        header_height = 100
        margin = 10  # Marge entre les deux bounding_box
        header_bottom_margin = 10  # Marge entre l'en-tête et le tableau

        # En-tête : Logo et Informations de l'entreprise
        bounding_box([0, cursor], width: bounds.width, height: header_height) do
          # Créer deux colonnes égales
          column_width = bounds.width / 2

          # Première colonne : Logo
          bounding_box([0, cursor], width: column_width, height: header_height) do
            image compagny.logo.path(:medium), width: 80, height: 40, position: :center, vposition: :baseline
            move_down 5  # Espacement entre le logo et le texte
            text compagny.name, size: 14, style: :bold, align: :center
            move_down 5
            text "Site web: #{compagny.website}", size: 12, style: :normal, align: :center
            move_down 5
            text "Pays: #{compagny.countrie}", size: 12, align: :center
          end

          # Deuxième colonne : Informations de l'entreprise
          bounding_box([column_width, cursor], width: column_width - margin, height: header_height) do
            move_down -80
            text "Téléphone: #{compagny.phoneNumber}", align: :right
            text "Ville: #{compagny.city}", size: 12, align: :right
            text "État: #{compagny.state}", size: 12, align: :right
            text "Adresse : #{compagny.address}", size: 12, align: :right
          end
        end

        # Assurer qu'il y a assez d'espace avant de commencer le tableau
        move_down header_bottom_margin
        # Titre du document
        text annonce.title, size: 24, style: :bold, align: :center
        move_down 20

        text annonce.description



        # Footer avec la date de génération
        move_down 20
        text "Fait le : #{Time.now.strftime('%d/%m/%Y')} à #{Time.now.strftime('%H:%M:%S')}", size: 10, align: :right
        move_down 20
        text annonce.announcement_type, size: 14,style: :bold, align: :right

      end
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
