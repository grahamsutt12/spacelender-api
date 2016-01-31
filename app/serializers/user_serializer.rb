class UserSerializer < ActiveModel::Serializer
  has_many :listings, :class_name => "Listing"
  has_one :image, :as => :imageable, :class_name => "Image"

  attributes :email, :role, :first_name, :last_name, :slug, :active, :auth_token

  def filter(keys)
    if meta && meta['auth_token']
      keys
    else
      keys -= [:auth_token]
    end
  end
end
