module Api
  class DocumentsController < ApplicationController
    before_action :set_folder
    before_action :set_document, only: [:show, :update, :destroy]

    # GET /api/folders/:folder_id/documents
    def index
      documents = @folder.documents
      render json: documents
    end

    # GET /api/folders/:folder_id/documents/:id
    def show
      render json: @document
    end

    # POST /api/folders/:folder_id/documents
    def create
      document = @folder.documents.new(document_params)
      if document.save
        render json: document, status: :created
      else
        render json: document.errors, status: :unprocessable_entity
      end
    end

    # PUT /api/folders/:folder_id/documents/:id
    def update
      if @document.update(document_params)
        render json: @document
      else
        render json: @document.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/folders/:folder_id/documents/:id
    def destroy
      @document.destroy
      head :no_content
    end

    private

    def set_folder
      @folder = Folder.find(params[:folder_id])
    end

    def set_document
      @document = @folder.documents.find(params[:id])
    end

    def document_params
      params.require(:document).permit(:title, :file)
    end
  end
end
