class Api::V1::PaymentsController < ApplicationController
  before_filter :authenticate

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

  def refund
    payment = @current_user.listings.find(params[:listing_id]).reservations.find_by_token(params[:reservation_id]).payment
    RefundPaymentWorker.perform_async(payment.id)
  end

  private
  def payment_params
    params.require(:payment).permit(:stripe_token, :card)
  end
end
