class Card < ActiveRecord::Base
  belongs_to :user

  attr_accessor :number, :exp_month, :exp_year, :cvc, :name, 
                :address_line1, :address_line2, :address_city, 
                :address_state, :address_country, :address_zip

  def self.generate_stripe_token(params)
    token = Stripe::Token.create(
      :card => {
        :number => params[:number],
        :exp_month => params[:exp_month],
        :exp_year => params[:exp_year],
        :cvc => params[:cvc],
        :name => params[:name],
        :address_line1 => params[:address_line1],
        :address_line2 => params[:address_line2],
        :address_city => params[:address_city],
        :address_state => params[:address_state],
        :address_country => params[:address_country],
        :address_zip => params[:address_zip]
      }
    )
  end

  def self.example_response
    JSON.pretty_generate([{"brand": "Visa","card_token": "card_1792sRD9UxLoQCaGhHB7ERgV","last4": "4242"}, {"brand": "MasterCard","card_token": "card_8923sRD9UxLoQCaGhHB7ERgV","last4": "5656"}])
  end

  def self.example_request
    JSON.pretty_generate({"card":{"number": "4242424242424242","exp_month": "11","exp_year": "2016","cvc": "314","name": "Graham Sutton","address_line1": "123 Lake Street","address_city": "Miami","address_state": "FL","address_country": "US","address_zip": "33333"}})
  end
end
