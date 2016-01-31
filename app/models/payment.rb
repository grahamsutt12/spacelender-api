class Payment < ActiveRecord::Base
  belongs_to :reservation

  enum :status => [:submitted, :approved, :declined, :refunded]

  before_create :generate_token


  ##
  # Process a charge for a payment. This is done in the background.
  ##
  def self.charge(reservation_id, payment_card)
    ChargePaymentWorker.perform_async(reservation_id, payment_card)
  end


  ##
  # Refund an exisiting payment. This is done in the background.
  ##
  def self.refund(payment_id)
    RefundPaymentWorker.perform_async(payment.id)
  end


  protected
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Payment.exists?(token: random_token)
    end
  end
end
