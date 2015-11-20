class Api::V1::PaymentsController < ApplicationController
  before_filter :authenticate

  api :POST, '/v1/listings/:listing_slug/reservations/:reservation_token/payments', "Submit a payment for a reservation."
  description "An example will be provided soon."

  def create
    reservation = @current_user.listings.find(params[:listing_id]).reservations.find_by_token(params[:reservation_id])
    payment = reservation.build_payment(payment_params)
    payment.card ||= params[:stripe_token]

    if payment.save
      ChargePaymentWorker.perform_async(reservation.id, payment.card)
      render :json => payment, :status => :ok
    else
      render :json => {:errors => payment.errors}, :status => :unprocessable_entity
    end
  end


  api :GET, '/v1/listings/:listing_slug/reservations/:reservation_token/payments/:payment_token', "Refund an existing approved payment."
  description "Refunds an already existing and approved payment. Payments can only be refunded if the reservation was cancelled prior to the start date."
  def refund
    payment = @current_user.listings.find(params[:listing_id]).reservations.find_by_token(params[:reservation_id]).payment
    RefundPaymentWorker.perform_async(payment.id)
  end

  private
  def payment_params
    params.require(:payment).permit(:stripe_token, :card)
  end
end
