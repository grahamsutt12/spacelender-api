class RateSerializer < ActiveModel::Serializer
  belongs_to :rateable

  attributes :amount, :time_type
end
