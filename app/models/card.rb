class Card < ActiveRecord::Base
  belongs_to :user

  validates :number, presence: true, length: { minimum: 13, maximum: 18 }
  validates :exp_month, length: { minimum: 2, maximum: 2 }
  validates :exp_year, length: { minimum: 2, maximum: 4 }

  ##
  # Use virtual attributes because we do not want to store the
  # user's credit card information on our servers. They will be
  # sent through the Stripe API.
  ##
  attr_accessor :number, :exp_month, :exp_year, :cvc, :name, 
                :address_line1, :address_line2, :address_city, 
                :address_state, :address_country, :address_zip


  ##
  # Generates a Stripe token for a given debit or credit card.
  # Refer to the validations for acceptance criteria.
  #
  # @param :card              => :hash
  # @param :number            => :string
  # @param :exp_month         => :string
  # @param :exp_year          => :string
  # @param :cvc               => :string
  # @param :name              => :string
  # @param :address_line1     => :string
  # @param :address_line2     => :string
  # @param :address_city      => :string
  # @param :address_state     => :string
  # @param :address_country   => :string
  # @param :address_zip       => :string
  ##
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

  # Example Response
  def self.example_response
    JSON.pretty_generate([{"brand": "Visa","card_token": "card_1792sRD9UxLoQCaGhHB7ERgV","last4": "4242"}, {"brand": "MasterCard","card_token": "card_8923sRD9UxLoQCaGhHB7ERgV","last4": "5656"}])
  end

  # Example Request
  def self.example_request
    JSON.pretty_generate({"card":{"number": "4242424242424242","exp_month": "11","exp_year": "2016","cvc": "314","name": "Graham Sutton","address_line1": "123 Lake Street","address_city": "Miami","address_state": "FL","address_country": "US","address_zip": "33333"}})
  end
end
