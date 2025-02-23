class ReservationMailer < ApplicationMailer
  default from: 'ziza97tiv@gmail.com' # Remplace par ton adresse

  def confirmation_email(reservation)
    @reservation = reservation
    mail(to: 'aziz@next-version.com', subject: "Confirmation de votre rendez-vous")
  end
end
