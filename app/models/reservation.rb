class Reservation < ActiveRecord::Base
  belongs_to :listing
  has_one :rate, :as => :rateable, :dependent => :destroy
  has_one :payment

  before_create :generate_token

  enum :status => [:requested, :accepted, :paid, :rejected, :canceled]

  accepts_nested_attributes_for :rate

  def self.example_request
    JSON.pretty_generate({"reservation":{"start": "Thu, 19 Nov 2015 03:06:07 -0500","end": "Sat, 21 Nov 2015 03:06:07 -0500","reason": "I want to, that's why.","rate_attributes":{"amount": 15,"time_type": "hourly"}}})
  end

  def self.example_response(action)
    if action == "index"
      JSON.pretty_generate([{"start": "2015-11-19T08:06:07.000Z","end": "2015-11-21T08:06:07.000Z","reason": "I want to, that's why.","status": "requested","token": "OILKxIySLYxQ_8QYGEeEnA","listing":{"name": "So Cool Listing","description": "This is the coolest listing","token": "kCsnBLteZgdWHP1fwtlpYQ","slug": "so-cool-listing"},"rate":{"amount":15.0,"time_type": "hourly"}},{"start": "2015-11-19T08:06:07.000Z","end": "2015-11-21T08:06:07.000Z","reason": "I want to, that's why.","status": "requested","token": "qZP82iY-9AAU-pYIfS6LMA","listing":{"name": "So Cool Listing","description": "This is the coolest listing","token": "kCsnBLteZgdWHP1fwtlpYQ","slug": "so-cool-listing"},"rate":{"amount": 15.0,"time_type": "hourly"}},{"start": "2015-11-19T08:06:07.000Z","end": "2015-11-21T08:06:07.000Z","reason": "I want to, that's why.","status": "requested","token": "WvM2gtEMnQZLYU3xGr992g","listing":{"name": "So Cool Listing","description": "This is the coolest listing","token": "OILKxIySLYxQ_8QYGEeEnA","slug": "so-cool-listing"},"rate":{"amount": 15.0,"time_type": "hourly"}}])
    elsif action == "show"
      JSON.pretty_generate({"start": "2015-11-19T08:06:07.000Z","end": "2015-11-21T08:06:07.000Z","reason": "I want to, that's why.","status": "requested","token": "WvM2gtEMnQZLYU3xGr992g","listing": {"name": "So Cool Listing","description": "This is the coolest listing","token": "kCsnBLteZgdWHP1fwtlpYQ","slug": "so-cool-listing"},"rate": {"amount": 15.0,"time_type": "hourly"}})
    end
  end

  protected
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Reservation.exists?(token: random_token)
    end
  end
end
