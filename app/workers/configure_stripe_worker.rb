class ConfigureStripeWorker
  include Sidekiq::Worker
  require 'stripe'

  def perform(user_id)
    user = User.find(user_id)

    ##
    # Creates the merchant account
    # Used for accepting payments from other users
    ##
    account = Stripe::Account.create({
      :country => "US",
      :managed => true,
      :email => user.email,
      :legal_entity => {
        :type => "individual",
        :business_name => "#{user.first_name} #{user.last_name}",
        :first_name => user.first_name,
        :last_name => user.last_name,
        :address => {
          :country => "US"
        }
      }
    })

    user.merchant_account = account.id
    user.access_code = account.keys.secret
    user.publishable_key = account.keys.publishable

    ##
    # Create the customer token
    # Allows for retrieval of customer information
    # such as: cards on file, payments made in the past, etc
    ##
    customer = Stripe::Customer.create(
      description: "#{user.first_name} #{user.last_name}'s customer account.",
      email: user.email
    )
    user.customer_token = customer.id


    user.save!
  end
end