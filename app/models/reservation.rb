class Reservation < ActiveRecord::Base
  belongs_to :listing
  has_one :rate, :as => :rateable, :dependent => :destroy
  has_one :payment

  before_create :generate_token

  enum :status => [:requested, :accepted, :paid, :rejected, :canceled]

  accepts_nested_attributes_for :rate

  def self.example
    JSON.pretty_generate({"reservation":{"start": "Thu, 19 Nov 2015 03:06:07 -0500","end": "Sat, 21 Nov 2015 03:06:07 -0500","reason": "I want to, that's why.","rate_attributes":{"amount": 15,"time_type": "hourly"}}})
  end

  protected
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Reservation.exists?(token: random_token)
    end
  end
end
