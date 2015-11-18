class Rate < ActiveRecord::Base
  belongs_to :rateable, polymorphic: true

  enum :time_type => [:hourly, :daily, :weekly, :monthly]
end
