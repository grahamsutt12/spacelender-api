class Api::V1::ReservationMailer < ApplicationMailer
  default from: "SpaceLender"

  def reservation_requested(user, reservation)
    @user = user
    @reservation = reservation

    mail(:to => @reservation.listing.user.email, 
         :subject => "Reservation Requested",
         :body => "Hi #{@reservation.listing.user.first_name},\n\n
                  A reservation for for your listing was just received from:
                  \n\n
                  #{@user.first_name} #{@user.last_name}
                  \n
                  From:\t#{@reservation.start.strftime('%B %-d, %Y')}
                  To:\t#{@reservation.end.strftime('%B %-d, %Y')}
                  #{api_v1_listing_reservation_url(@reservation.listing, @reservation.token)}"
    )
  end
end
