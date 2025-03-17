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
    stats = Sale.group(:user_id).count
    render json: { sales_by_employee: stats }, status: :ok
  end

  def all_personnel
    personnnels = Personnel.all
    render json: { count: personnnels.count }, status: :ok
  end
end
