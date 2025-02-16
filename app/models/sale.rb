class Sale < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  has_many :sale_items, dependent: :destroy
  has_many :payments, dependent: :destroy

  validates :buyer_name, :channel, :total_price, presence: true
  validates :paid_amount, numericality: { greater_than_or_equal_to: 0 }


  before_save :update_remaining_amount

  private

  def update_remaining_amount
    self.remaining_amount = total_price.to_f - paid_amount.to_f
  end
end
