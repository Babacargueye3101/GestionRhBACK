class Subscription < ApplicationRecord
  belongs_to :subscription_type
  belongs_to :client
  before_create :generate_card_number

  validates :subscription_type_id, :client_id, presence: true

  private

  def generate_card_number
    last_number = Subscription.where(subscription_type: subscription_type).count + 1
    self.card_number = "#{last_number}#{subscription_type.letter}"
  end
end
