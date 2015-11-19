class Api::V1::ReservationsController < ApplicationController
  before_filter :authenticate

  api :GET, "/v1/listings/:listing_slug/reservations/:reservation_token", "Show a specific reservation for specific listing."
  param :listing_slug, String, "The listing's slug.", :required => true
  param :reservation_token, String, "The reservation's reference token.", :required => true
  def show
    listings = @current_user.listings
    reservation = listings.find_by_token(params[:id])

    render :json => reservation, :status => :ok
  end



  api :POST, "/v1/listings/:listing_slug/reservations", "Create a reservation for a specific listing."
  example Reservation.example
  param :reservation, Hash do
    param :start, String, "The start datetime of the reservation. Pass in 12AM if the reservation rate is daily, weekly, or monthly. If hourly, then specify the hour and minutes.", :required => true
    param :end, String, "The end datetime of the reservation. Pass in 12AM if the reservation rate is daily, weekly, or monthly. If hourly, then specify the hour and minutes.", :required => true
    param :reason, String, "An explanation of the user's purpose for the reservation."

    param :rate_attributes, Hash, "The selected rate's attributes.", :required => true do
      param :amount, :number, "The selected rate's amount.", :required => true
      param :time_type, ["hourly", "daily", "weekly", "monthly"], "The type of time period the rate amount reflects.\ne.g. $12 per hour, $200 per week, etc...", :required => true
    end
  end

  def create
    listing = @current_user.listings.find(params[:listing_id])
    reservation = listing.reservations.build(reservation_params)

    if reservation.save
      ReservationRequestedWorker.perform_async(listing.user.slug, reservation.token)
      render :json => reservation, :status => :ok
    else
      render :json => {:errors => reservation.errors}, :status => :unprocessable_entity
    end
  end



  api :DELETE, "/v1/listings/:listing_slug/reservations/:reservation_token", "Cancel a reservation for a specific listing."
  param :listing_slug, String, "The listing's slug.", :required => true
  param :reservation_token, String, "The reservation's reference token.", :required => true
  description "This cancels a specified reservation. It does not completely delete it. The reservation is needed for record keeping."
  def destroy
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
