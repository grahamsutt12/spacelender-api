class Api::V1::ReservationsController < ApplicationController
  before_filter :authenticate


  api :GET, '/v1/listings/:listing_slug/reservations', "Show all reservations for a specific listing."
  description "Below is an example of an expected response. Returns Array."
  example Reservation.example_response("index")
  def index
    reservations = @current_user.listings.find(params[:listing_id]).reservations
    render :json => reservations, :status => :ok
  end



  api :GET, "/v1/listings/:listing_slug/reservations/:reservation_token", "Show a specific reservation for specific listing."
  description "Below is an example of an expected repsonse. Returns Hash."
  example Reservation.example_response("show")
  def show
    listing = @current_user.listings.find(params[:listing_id])
    reservation = listing.reservations.find_by_token(params[:id])

    render :json => reservation, :status => :ok
  end



  api :POST, "/v1/listings/:listing_slug/reservations", "Create a reservation for a specific listing."
  description "It should be noted that a reservation only accepts ONE \"rate\" hash, unlike listings which accept an array. Please keep this in mind."
  example Reservation.example_request
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
  description "This cancels a specified reservation. It does not completely delete it. The reservation is needed for record keeping. Below are examples of the response you can expect for successfully or unsuccessfully canceling a reservation."
  example JSON.pretty_generate({"success": "Reservation was succesfully canceled."})
  example JSON.pretty_generate({"errors": "Reservation was unable to be canceled."})
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
