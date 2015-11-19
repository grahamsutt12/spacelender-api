class Api::V1::PaymentsController < ApplicationController
  before_filter :authenticate

  api :POST, '/v1/listings/:listing_slug/reservations/:reservation_token/payments', "Submit a payment for a reservation."
  param :listing_slug, String, "The listing's slug.", :required => true
  param :reservation_slug, String, "The reservation's token identifier.", :required => true
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
  param :listing_slug, String, "The listing's slug.", :required => true
  param :reservation_slug, String, "The reservation's token identifier.", :required => true
  param :payment_token, String, "The payment's token identifier.", :required => true
  def refund
    payment = @current_user.listings.find(params[:listing_id]).reservations.find_by_token(params[:reservation_id]).payment
    RefundPaymentWorker.perform_async(payment.id)
  end

  private
  def payment_params
    params.require(:payment).permit(:stripe_token, :card)
  end
end
