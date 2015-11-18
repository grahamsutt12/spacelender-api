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

  protected
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Reservation.exists?(token: random_token)
    end
  end
end
