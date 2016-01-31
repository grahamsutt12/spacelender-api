class ReservationSerializer < ActiveModel::Serializer
  belongs_to :listing, :class_name => "Listing"
  has_one :rate, :as => :rateable, :class_name => "Rate"

  attributes :start, :end, :reason, :status, :token, :booked_by
end
