class UserSerializer < ActiveModel::Serializer
  has_many :listings, :class_name => "Listing"
  has_one :image, :as => :imageable, :class_name => "Image"

  attributes :email, :role, :first_name, :last_name, :slug, :active
end
