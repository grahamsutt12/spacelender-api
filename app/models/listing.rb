class Listing < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, :use => [:slugged, :finders]

  belongs_to :user
  has_one :location, :dependent => :destroy
  has_many :reservations, :dependent => :destroy
  has_many :images, :as => :imageable, :dependent => :destroy
  has_many :rates, :as => :rateable, :dependent => :destroy

  before_create :generate_token

  accepts_nested_attributes_for :images, :rates, :location

  def slug_candidates
    [:name]
  end

  def self.example_request
    JSON.pretty_generate({"listing":{"name": "So Cool Listing","description": "This is the coolest listing","images_attributes":[{"path": "/Users/graham1/Downloads/room02.jpg","caption": "This is picture number one."},{"path": "/Users/graham1/Downloads/room03.jpg","caption": "This is picture number two."}],"location_attributes":{"address": "123 Lake Street","city": "Miami","state": "FL","country": "United States","zip": "33333"},"rates_attributes":[{"amount": "14","time_type": "hourly"},{"amount": "100","time_type": "daily"}]}})
  end

  def self.example_response
    JSON.pretty_generate({"name": "So Cool Listing","description": "This is the coolest listing","token": "kCsnBLteZgdWHP1fwtlpYQ","slug": "so-cool-listing","user":{"email": "grahamsutton1@gmail.com","role": "employee","first_name": "Graham","last_name": "Sutton","slug": "graham-283384","active": true},"location":{"address": "123 Lake Street","city": "Miami","state": "FL","country": "United States","zip": "33014","latitude": 25.894675,"longitude": -80.311862},"reservations":[{"start": "2015-11-19T08:06:07.000Z","end": "2015-11-21T08:06:07.000Z","reason": "I want to, that's why.","status": "requested","token": "OILKxIySLYxQ_8QYGEeEnA"},{"start": "2015-11-19T08:06:07.000Z","end": "2015-11-21T08:06:07.000Z","reason": "I want to, that's why.","status": "requested","token": "qZP82iY-9AAU-pYIfS6LMA"},{"start": "2015-11-19T08:06:07.000Z","end": "2015-11-21T08:06:07.000Z","reason": "I want to, that's why.","status": "requested","token": "WvM2gtEMnQZLYU3xGr992g"}],"images":[{"file_name": "room02","url": "http://res.cloudinary.com/spacelender-cloud/image/upload/v1447640328/ra9jejwsxvrwyjgbeomh.jpg","caption": "This is picture number one."},{"file_name": "room03","url": "http://res.cloudinary.com/spacelender-cloud/image/upload/v1447640330/uxm2l5bdhr2pecj5lqdb.jpg","caption": "This is my new caption"}],"rates":[{"amount": 100,"time_type": "daily"},{"amount": 14,"time_type": "hourly"}]})
  end

  protected
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Reservation.exists?(token: random_token)
    end
  end
end
