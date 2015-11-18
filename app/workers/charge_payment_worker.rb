class ChargePaymentWorker
  include Sidekiq::Worker

  def perform(reservation_id, payment_method)
    reservation = Reservation.find(reservation_id)
    amount = reservation.rate.amount

    begin
      charge = Stripe::Charge.create({
        :amount => amount * 100,      # Amount is based in cents
        :source => payment_method,    # Existing card token or Stripe token
        :currency => "usd",
        :description => "Test Charge",
        :statement_descriptor => "Reservation Charge",
        :application_fee => (amount * ENV['application_fee'].to_f).to_i
      },{
        :stripe_account => reservation.listing.user.merchant_account
      })

      reservation.payement.charge = charge.id
      reservation.payment.paid! unless !charge
      reservation.payment.save
    rescue
      charge = nil
      reservation.payment.declined!
    end
  end
end