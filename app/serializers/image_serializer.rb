class ImageSerializer < ActiveModel::Serializer
  belongs_to :imageable
  attributes :file_name, :url, :caption
end
