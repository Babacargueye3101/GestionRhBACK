class Reservation < ApplicationRecord
  belongs_to :client
  belongs_to :availability

  validates :time, presence: true
  validates :status, inclusion: { in: %w[pending confirmed cancelled] }

  #after_update :send_notification, if: -> { status_changed? && confirmed? }

  private

  # def send_notification
  #   # Logique pour envoyer un email et une notification WhatsApp
  #   NotificationService.send_email(client.email, "Votre RDV est confirmé !")
  #   NotificationService.send_whatsapp(client.phone, "Votre RDV pour #{availability.date} à #{time} est confirmé.")
  # end

  def confirmed?
    status == "confirmed"
  end
end
