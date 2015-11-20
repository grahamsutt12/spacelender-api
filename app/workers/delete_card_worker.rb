class DeleteCardWorker
  include Sidekiq::Worker

  def perform(user_id, card_token)
    user = User.find(user_id)
    customer_account = Stripe::Customer.retrieve(user.customer_token)
    customer_account.sources.retrieve(card_token).delete
  end
end