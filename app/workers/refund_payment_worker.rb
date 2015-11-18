class RefundPaymentWorker
  include Sidekiq::Worker

  def perform(payment_id)
    payment = Payment.find(payment_id)

    refund = Stripe::Refund.create({
      :charge => payment.charge,
      :refund_application_fee => true
    },
    {
      :stripe_account => payment.reservation.listing.user.merchant_account
    })

    payment.refunded! unless !refund
  end
end