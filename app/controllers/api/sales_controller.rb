class Api::SalesController < ApplicationController
  skip_before_action :verify_authenticity_token  # 🔥 Désactive CSRF
  before_action :authenticate_user_token_token!
  before_action :set_shop
  before_action :set_sale, only: [:show, :update, :destroy]

  # ✅ Lister les ventes d'une boutique
  def index
    sales = @shop.sales.includes(:user, :payments, :sale_items).page(params[:page]).per(10)
    render json: sales, status: :ok
  end
      # ✅ Voir les details de ventes d'une boutique
  def show
    sale = @shop.sales.includes(:sale_items).find(params[:id])
  
    sale_data = {
      id: sale.id,
      buyer_name: sale.buyer_name,
      buyer_surname: sale.buyer_surname,
      channel: sale.channel,
      total_price: sale.total_price,
      paid_amount: sale.paid_amount,
      payment_method: sale.payment_method,
      delivered: sale.delivered,
      sale_date: sale.sale_date,
      sale_items: sale.sale_items.map do |item|
        {
          product_id: item.product_id,
          product_name: item.product.name,
          quantity: item.quantity,
          price: item.price,
          subtotal: item.quantity * item.price
        }
      end
    }
  
    render json: { sale: sale_data }, status: :ok
  end
  # ✅ Créer une vente
  def create
    sale = @shop.sales.new(sale_params)
    sale.user = current_user
  # Calculer total_price en fonction des produits
    total_price = 0

    params[:products].each do |product|
      total_price += product[:quantity] * product[:price]
    end

    sale.total_price = total_price # Mettre à jour le total_price calculé

    if sale.save
      params[:products].each do |product|
        sale.sale_items.create(product_id: product[:id], quantity: product[:quantity], price: product[:price])
      end
      render json: sale, status: :created
    else
      render json: { errors: sale.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Mise à jour d'une vente
  def update
    if @sale.update(sale_params)
      render json: @sale, status: :ok
    else
      render json: { errors: @sale.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ Suppression d'une vente
  def destroy
    @sale.destroy
    head :no_content
  end

  # ✅ Télécharger une facture
  def download_invoice
    sale = @shop.sales.includes(:sale_items).find(params[:id])
    pdf = Prawn::Document.new

    # Ajout du logo et du titre
    pdf.text "FACTURE", size: 20, style: :bold, align: :right
    pdf.move_down 20

    # Informations de l'entreprise et du client
    pdf.text "Nom de l'entreprise", style: :bold
    pdf.text "Adresse"
    pdf.text "Code Postal et Ville"
    pdf.text "Numéro de téléphone"
    pdf.text "Email"
    
    pdf.move_down 10
    pdf.text "N° de facture : ID-#{sale.id}", style: :bold
    pdf.text "Date de facturation : #{sale.created_at.strftime('%d/%m/%Y')}"
    pdf.text "Échéance : #{(sale.created_at + 30.days).strftime('%d/%m/%Y')}"

    pdf.move_down 10
    pdf.text "Nom du client : #{sale.buyer_name} #{sale.buyer_surname}", style: :bold

    pdf.move_down 20
    pdf.text "Objet : Vente de produits", style: :bold

    # Table des articles
    data = [["QUANTITÉ", "DÉSIGNATION", "PRIX UNIT", "MONTANT"]]
    sale.sale_items.each do |item|
      data << [
        item.quantity,
        "Article - #{item.product.name}",
        "#{item.price} fcfa",
        "#{item.quantity * item.price} fcfa"
      ]
    end

    pdf.table(data, header: true, width: pdf.bounds.width)

    pdf.move_down 20

    # Montant total
    pdf.text "MONTANT TOTAL : #{sale.total_price} fcfa", style: :bold
    pdf.text "MONTANT PAYÉ : #{sale.paid_amount } fcfa", style: :bold
    pdf.text "RESTANT : #{sale.remaining_amount} fcfa", size: 16, style: :bold, color: "ff0000"

    pdf.move_down 30
    pdf.text "Conditions et modalités de paiement :", style: :bold
    pdf.text "Le paiement est dû dans 30 jours"

    send_data pdf.render,
              filename: "facture_#{sale.id}.pdf",
              type: "application/pdf",
              disposition: "attachment"
  end


  # ✅ Télécharger une facture
  # def download_invoice
  #   sale = @shop.sales.includes(:sale_items).find(params[:id])
  
  #   pdf = Prawn::Document.new
  #   pdf.text "Facture de Vente ##{sale.id}", size: 20, style: :bold
  #   pdf.move_down 10
  
  #   pdf.text "Nom du Client : #{sale.buyer_name} #{sale.buyer_surname}", size: 12
  #   pdf.text "Canal de Vente : #{sale.channel}", size: 12
  #   pdf.text "Date de Vente : #{sale.sale_date.strftime('%d/%m/%Y')}", size: 12
  #   pdf.text "Méthode de Paiement : #{sale.payment_method}", size: 12
  #   pdf.text "Montant Total : #{sale.total_price} FCFA", size: 12
  #   pdf.text "Montant Payé : #{sale.paid_amount} FCFA", size: 12
  #   pdf.text "Montant Restant : #{sale.remaining_amount} FCFA", size: 12
  #   pdf.move_down 10
  
  #   pdf.text "Détails des Produits :", size: 14, style: :bold
  #   pdf.move_down 5
  
  #   sale.sale_items.each do |item|
  #     pdf.text "#{item.product.name} - Quantité: #{item.quantity} - Prix Unitaire: #{item.price} FCFA - Total: #{item.quantity * item.price} FCFA", size: 12
  #   end
  
  #   pdf.move_down 20
  #   pdf.text "Merci pour votre achat !", size: 12, style: :italic
  
  #   # Rendre le fichier téléchargeable
  #   send_data pdf.render, filename: "facture_vente_#{sale.id}.pdf", type: "application/pdf", disposition: "attachment"
  # end
  

  private

  def set_shop
    @shop = current_user.shops.find_by(id: params[:shop_id])
    render json: { error: "Shop not found" }, status: :not_found unless @shop
  end

  def set_sale
    @sale = @shop.sales.find_by(id: params[:id])
    render json: { error: "Sale not found" }, status: :not_found unless @sale
  end

  def sale_params
    params.require(:sale).permit(:buyer_name, :buyer_surname, :channel, :paid_amount, :payment_method, :delivered, :sale_date)
  end
end
