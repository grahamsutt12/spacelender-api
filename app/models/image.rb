class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  attr_accessor :path

  def self.example_response(action)
    if action == "index"
      JSON.pretty_generate([{"file_name": "room02","url": "http://res.cloudinary.com/spacelender-cloud/image/upload/v1447640328/ra9jejwsxvrwyjgbeomh.jpg","caption": "This is picture number one.","imageable":{"name": "So Cool Listing","description": "This is the coolest listing","token": "kCsnBLteZgdWHP1fwtlpYQ","slug": "so-cool-listing"}},{"file_name": "room03","url": "http://res.cloudinary.com/spacelender-cloud/image/upload/v1447640330/uxm2l5bdhr2pecj5lqdb.jpg","caption": "This is my new caption","imageable": {"name": "So Cool Listing","description": "This is the coolest listing","token": "kCsnBLteZgdWHP1fwtlpYQ","slug": "so-cool-listing"}}])
    elsif action == "show"
      JSON.pretty_generate({"file_name": "room03","url": "http://res.cloudinary.com/spacelender-cloud/image/upload/v1447640330/uxm2l5bdhr2pecj5lqdb.jpg","caption": "This is my new caption","imageable":{"name": "So Cool Listing","description": "This is the coolest listing","token": "kCsnBLteZgdWHP1fwtlpYQ","slug": "so-cool-listing"}})
    end
  end

  def self.example_request
    JSON.pretty_generate({"image": {"caption": "This is my new caption"}})
  end
end
