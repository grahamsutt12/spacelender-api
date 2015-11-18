class Payment < ActiveRecord::Base
  belongs_to :reservation

  enum :status => [:submitted, :approved, :declined, :refunded]

  before_create :generate_token

  protected
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Payment.exists?(token: random_token)
    end
  end
end
