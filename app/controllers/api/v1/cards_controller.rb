class Api::V1::CardsController < ApplicationController
  before_filter :authenticate

  api :GET, "/v1/users/:user_slug/cards", "Show all cards on file belonging to the current user."
  description "Below is an example of an expected response. Returns Array."
  example Card.example_response
  def index
    render :json => @current_user.cards, :status => :ok
  end



  api :POST, "/v1/users/:user_slug/cards", "Store a new card for the user."
  description "Below is an example of how to format the request for storing a new card for the current user."
  example Card.example_request
  param :card, Hash, :required => true do
    param :number, String, "The card number.", :required => true
    param :exp_month, String, "The card expiration month.", :required => true
    param :exp_year, String, "The card expiration year.", :required => true
    param :cvc, String, "The card CVC code. The 3 or 4 digit code usually found on the the back of the card.", :required => true
    param :name, String, "The name on the card."
    param :address_line1, String, "The billing address for the card."
    param :address_line2, String, "Additional line for the card billing address."
    param :address_city, String, "The city for the billing address."
    param :address_state, String, "The state for the billing address."
    param :address_country, String, "The country for the billing address."
    param :address_zip, String, "The zip/postal code for the billing address."
  end

  def create
    card = @current_user.cards.build
    token = Card.generate_stripe_token(card_params)

    customer_account = Stripe::Customer.retrieve(@current_user.customer_token)
    card_response = customer_account.sources.create(:source => token)
    card.card_token = card_response.id
    card.last4 = card_response.last4
    card.brand = card_response.brand

    if card.save
      render :json => card, :status => :ok
    else
      render :json => {:errors => card.errors}, :status => :unprocessable_entity
    end
  end


  api :DELETE, "/v1/users/:user_slug/cards/:card_token", "Delete a card for the specific user."
  description "Below is an example of the response you could expect for successfully or unsuccessfully deleting a card."
  example JSON.pretty_generate({"success": "The card was succesfully deleted."})
  example JSON.pretty_generate({"errors": "The card was unable to be deleted."})

  def destroy
    card = @current_user.cards.find_by_card_token(params[:id])
    card_token = card.card_token

    if card.destroy
      DeleteCardWorker.perform_async(@current_user.id, card_token)
      render :json => {:success => "The card was succesfully deleted."}, :status => :ok
    else
      render :json => {:errors => "The card was unable to be deleted."}, :status => :unprocessable_entity
    end
  end

  private
  def card_params
    params.require(:card).permit(:number, :exp_month, :exp_year, :cvc, :name, :address_line1, :address_line2, :address_city, :address_state, :address_country, :address_zip)
  end
end
