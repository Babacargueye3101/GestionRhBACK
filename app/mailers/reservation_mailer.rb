class ReservationMailer < ApplicationMailer
  default from: 'ziza97tiv@gmail.com' # Remplace par ton adresse

  def confirmation_email(user, reservation)
    @user = user
    @reservation = reservation
    mail(to: @reservation&.client&.email, subject: "Confirmation de votre rendez-vous")
  end
end
