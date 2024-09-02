require 'csv'

require 'prawn'
require 'prawn/table'

class Api::PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]


  respond_to :json, :csv, :pdf

  def index
    if params[:role] === 'admin'
      @payments = Payment.page(params[:page]).per(params[:per_page] || 10)
      .where(compagny_id: params[:compagny_id])
      .order(updated_at: :desc)
    else
      employee = Employee.find_by(email: params[:email])
      @payments = employee.payments.page(params[:page]).per(params[:per_page] || 10)
                          .order(updated_at: :desc)
    end


    respond_to do |format|
      format.json do
        render json: {
          payments: @payments.as_json(include: {
            employee: { only: [:id, :first_name, :last_name, :phone, :position, :gender] }
          })
        }
      end
      format.csv do
        send_data generate_csv(@payments), filename: "payments-#{Date.today}.csv", type: 'text/csv'
      end

      format.pdf do
        pdf = generate_pdf(@payments)
        send_data pdf.render, filename: "facture-#{Date.today}.pdf", type: 'application/pdf'
      end

    end
  end

  def getAllPayment
    @payments = Payment.where(compagny_id: params[:compagny_id])
                       .order(updated_at: :desc)

    respond_to do |format|
      format.json do
        render json: {
          payments: @payments.as_json(include: {
            employee: { only: [:id, :first_name, :last_name, :phone, :position, :gender] }
          })
        }
      end
    end
  end

  # GET /payments/:id
  def show
    respond_to do |format|
      format.json { render json: @payment }
      format.pdf do
        pdf = generate_single_payment_pdf(@payment)
        send_data pdf.render, filename: "facture-#{@payment.id}-#{Date.today}.pdf", type: 'application/pdf'
      end
    end
  end

  # POST /payments
  def create
    @payment = Payment.new(payment_params)
    if @payment.save
      render json: @payment, status: :created
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /payments/:id
  def update
    if @payment.update(payment_params)
      render json: @payment
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /payments/:id
  def destroy
    @payment.destroy
    head :no_content
  end

  private

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(:amount, :status, :employee_id, :payment_method, :reference_number, :payment_date, :compagny_id)
  end

  private


  def generate_pdf(payments)
    compagny = Compagny.find(params[:compagny_id])

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
          image compagny.url, width: 80, height: 40, position: :center, vposition: :baseline
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
          text "Address : #{compagny.address}", size: 12, align: :right
        end
      end

      # Assurer qu'il y a assez d'espace avant de commencer le tableau
      move_down header_bottom_margin

      # Titre du document
      text "Paiement de Salaire", size: 24, style: :bold, align: :center
      move_down 20

      # Création du tableau
      table_data = [["Employé", "Montant (FCFA)", "Date du Paiement", "Payé par", "Reference transaction", "Statut"]]

      payments.each do |payment|
        table_data << [
          "#{payment.employee.first_name} #{payment.employee.last_name}",
          payment.amount,
          payment.payment_date.strftime("%d/%m/%Y"),
          payment.payment_method.upcase,
          payment.reference_number,
          payment.status.capitalize
        ]
      end

      # Insérer le tableau
      table(table_data, header: true, row_colors: ["F0F0F0", "FFFFFF"], position: :center, cell_style: { borders: [:top, :bottom, :left, :right], border_width: 0.5 }) do |t|
        t.row(0).font_style = :bold
        t.columns(1..5).align = :center
        t.header = true
      end

      # Footer avec la date de génération
      move_down 20
      text "Fait le : #{Time.now.strftime('%d/%m/%Y')} à #{Time.now.strftime('%H:%M:%S')}", size: 10, align: :right
    end
  end


  def generate_single_payment_pdf(payment)
    compagny = Compagny.find(params[:compagny_id])
    url =url_for(compagny.logo)
    Prawn::Document.new(page_size: 'A4', page_layout: :portrait) do
      header_height = 100
      margin = 10
      header_bottom_margin = 10

      bounding_box([0, cursor], width: bounds.width, height: header_height) do
        column_width = bounds.width / 2

        bounding_box([0, cursor], width: column_width, height: header_height) do
          if compagny.logo.attached?
            image url, width: 80, height: 40, position: :center, vposition: :baseline
          else
            text "Logo non disponible", align: :center
          end
          move_down 5
          text compagny.name, size: 14, style: :bold, align: :center
          move_down 5
          text "Site web: #{compagny.website}", size: 12, align: :center
          move_down 5
          text "Pays: #{compagny.countrie}", size: 12, align: :center
        end

        bounding_box([column_width, cursor], width: column_width - margin, height: header_height) do
          move_down -80
          text "Téléphone: #{compagny.phoneNumber}", align: :right
          text "Ville: #{compagny.city}", size: 12, align: :right
          text "État: #{compagny.state}", size: 12, align: :right
          text "Adresse : #{compagny.address}", size: 12, align: :right
        end
      end

      move_down header_bottom_margin
      text "Paiement de Salaire", size: 24, style: :bold, align: :center
      move_down 20

      table_data = [["Employé", "Montant (FCFA)", "Date du Paiement", "Payé par", "Référence transaction", "Statut"]]

      table_data << [
        "#{payment.employee.first_name} #{payment.employee.last_name}",
        payment.amount,
        payment.payment_date.strftime("%d/%m/%Y"),
        payment.payment_method.upcase,
        payment.reference_number,
        payment.status.capitalize
      ]

      table(table_data, header: true, row_colors: ["F0F0F0", "FFFFFF"], position: :center, cell_style: { borders: [:top, :bottom, :left, :right], border_width: 0.5 }) do |t|
        t.row(0).font_style = :bold
        t.columns(1..5).align = :center
      end

      move_down 20
      text "Fait le : #{Time.now.strftime('%d/%m/%Y')} à #{Time.now.strftime('%H:%M:%S')}", size: 10, align: :right
    end
  end






  def generate_csv(payments)
    CSV.generate(headers: true) do |csv|
      csv << ['ID', 'Employee ID', 'Payment Date', 'Amount', 'Payment Method', 'Reference Number', 'Status', 'Created At', 'Updated At', 'Company ID', 'Employee First Name', 'Employee Last Name']

      payments.each do |payment|
        csv << [
          payment.id,
          payment.employee_id,
          payment.payment_date,
          payment.amount,
          payment.payment_method,
          payment.reference_number,
          payment.status,
          payment.created_at,
          payment.updated_at,
          payment.compagny_id,
          payment.employee.first_name,  # Assurez-vous que l'association existe
          payment.employee.last_name      # Assurez-vous que l'association existe
        ]
      end
    end
  end
end
