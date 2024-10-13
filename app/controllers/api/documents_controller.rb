class Api::DocumentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  # GET /api/folders/:folder_id/documents
  def index
    folder_id = params['folder_id']
    documents = Document.where(folder_id: folder_id)

    documents = documents.map do |document|
      {
        id: document.id,
        title: document.title,
        description: document.description,
        created_at: document.created_at,
        file_url: document.file.attached? ? url_for(document.file) : nil, # Utilisation de url_for
        file_size: document.file.byte_size, # Utiliser byte_size pour Active Storage
        file_name: document.file.filename.to_s # Utiliser filename pour Active Storage
      }
    end

    render json: documents
  end

  # GET /api/folders/:folder_id/documents/:id
  def show
    document = Document.find(params[:id])
    render json: document
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      render json: { message: 'Document créé avec succès' }, status: :created
    else
      render json: { errors: @document.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def document_params
    params.require(:document).permit(:title, :description, :file, :folder_id)
  end
end
