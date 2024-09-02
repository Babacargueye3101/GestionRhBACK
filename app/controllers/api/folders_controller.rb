module Api
  class FoldersController < ApplicationController
    before_action :set_folder, only: [:show, :update, :destroy]
    skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]

    # GET /api/folders
    def index
      folders = Folder.all
      render json: folders
    end

    # GET /api/folders/:id
    def show
      render json: @folder, include: :documents
    end

    # POST /api/folders
    def create
      folder = Folder.new(folder_params)
      if folder.save
        render json: folder, status: :created
      else
        render json: folder.errors, status: :unprocessable_entity
      end
    end

    # PUT /api/folders/:id
    def update
      if @folder.update(folder_params)
        render json: @folder
      else
        render json: @folder.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/folders/:id
    def destroy
      @folder.destroy
      head :no_content
    end

    private

    def set_folder
      @folder = Folder.find(params[:id])
    end

    def folder_params
      params.require(:folder).permit(:name, :compagny_id)
    end
  end
end
