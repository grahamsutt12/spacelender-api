class Api::V1::ReservationsController < ApplicationController
  before_filter :authenticate

  def show
    listings = @current_user.listings
    reservation = listings.find_by_token(params[:id])

    render :json => reservation, :status => :ok
  end

  def create
    listing = Listing.find(params[:listing_id])
    reservation = listing.reservations.build(reservation_params)

    if reservation.save
      ReservationRequestedWorker.perform_async(listing.user.slug, reservation.token)
      render :json => reservation, :status => :ok
    else
      render :json => {:errors => reservation.errors}, :status => :unprocessable_entity
    end
  end

  def destroy
    ### 
    # This method makes the reservation inactive, it does not completely 
    # destroy the reservation. The reservation and its data is needed for 
    # record keeping.
    ###

    reservation = Reservation.find_by_token(params[:id])
    reservation.canceled!

    if reservation.status == "canceled"
      render :json => {"success": "Reservation was succesfully canceled."}, :status => :ok
    else
      render :json => {"errors": "Reservation was unable to be canceled."}, :status => :unprocessable_entity
    end
  end

  private
  def reservation_params
    params.require(:reservation).permit(:start, :end, :reason, rate_attributes: [:amount, :time_type])
  end
end
