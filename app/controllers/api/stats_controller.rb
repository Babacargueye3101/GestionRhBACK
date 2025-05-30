class Api::StatsController < ApplicationController
  before_action :authenticate_user_token_token!

  def sales_by_channel
    stats = Sale.group(:channel).count
    render json: { sales_by_channel: stats }, status: :ok
  end

  def sales_trends
    stats = Sale.group_by_day(:sale_date).sum(:total_price)
    render json: { sales_trends: stats }, status: :ok
  end

  def top_sales_and_loyal_customers
    top_sales = Product.joins(:sale_items)
                       .group(:id, :name)
                       .order('SUM(sale_items.quantity) DESC')
                       .limit(5)
                       .sum('sale_items.quantity')

    loyal_customers = Sale.group(:buyer_name, :buyer_surname)
                          .order('COUNT(id) DESC')
                          .limit(5)
                          .count

    render json: {
      top_sales: top_sales.map { |(id, name), qty| { product_id: id, product_name: name, quantity_sold: qty } },
      loyal_customers: loyal_customers.map { |(name, surname), count| { name: name, surname: surname, purchase_count: count } }
    }, status: :ok
  end

  def payment_usage_stats
    stats = Sale.group(:payment_method).count
    render json: { payment_usage: stats }, status: :ok
  end

  def sales_by_employee
    stats = Sale.joins(:user)
                .group(:user_id, 'users.name')
                .count

    sales_by_employee = stats.map do |(user_id, user_name), count|
      {
        user_id: user_id,
        user_name: user_name,
        sales_count: count
      }
    end

    render json: { sales_by_employee: sales_by_employee }, status: :ok
  end

  def all_personnel
    personnnels = Personnel.all
    render json: { count: personnnels.count }, status: :ok
  end

  # ✅ Méthode pour obtenir le nombre total de ventes, de réservations en attente et de souscriptions aux cartes
  def summary_stats
    total_sales = Sale.count
    pending_reservations = Reservation.where(status: 'pending').count
    total_subscriptions = Subscription.count

    render json: {
      total_sales: total_sales,
      pending_reservations: pending_reservations,
      total_subscriptions: total_subscriptions
    }, status: :ok
  end

  # Méthode pour obtenir les statistiques des commandes par méthode de paiement avec le statut "delivered"
  def orders_by_payment_method
    # Récupérer les commandes avec le statut "delivered"
    delivered_orders = Order.where(status: 'delivered')
    
    # Grouper les commandes par méthode de paiement et calculer le total
    payment_stats = delivered_orders.group(:payment_method).sum(:total)
    
    # Compter le nombre de commandes par méthode de paiement
    payment_counts = delivered_orders.group(:payment_method).count
    
    # Formater les résultats
    result = payment_stats.map do |method, total|
      {
        payment_method: method,
        total_amount: total,
        order_count: payment_counts[method] || 0
      }
    end
    
    # Calculer le total global
    total_amount = delivered_orders.sum(:total)
    
    render json: {
      payment_methods: result,
      total_delivered_amount: total_amount,
      total_delivered_orders: delivered_orders.count
    }, status: :ok
  end

end
