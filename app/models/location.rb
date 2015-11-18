class Location < ActiveRecord::Base
  belongs_to :listing

  geocoded_by :full_street_address
  after_validation :geocode

  def full_street_address
    "#{address}, #{city}, #{state}, #{country} #{zip}"
  end
end
