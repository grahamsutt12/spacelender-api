class Reservation < ActiveRecord::Base
  belongs_to :listing
  has_one :rate, :as => :rateable, :dependent => :destroy
  has_one :payment

  before_create :generate_token

  enum :status => [:requested, :accepted, :paid, :rejected, :canceled]

  accepts_nested_attributes_for :rate

  protected
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Reservation.exists?(token: random_token)
    end
  end
end
