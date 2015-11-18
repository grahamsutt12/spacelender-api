class ListingSerializer < ActiveModel::Serializer
  belongs_to :user, :class_name => "User"
  has_one :location, :class_name => "Location"
  has_many :reservations, :class_name => "Reservation"
  has_many :images, :as => :imageable, :class_name => "Image"
  has_many :rates, :as => :rateable, :class_name => "Rate"

  attributes :name, :description, :token, :slug
end
