class LocationSerializer < ActiveModel::Serializer
  belongs_to :listing, :class_name => "Listing"

  attributes :address, :city, :state, :country, :zip, :latitude, :longitude
end
