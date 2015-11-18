class ListingImageUploadWorker
  include Sidekiq::Worker

  def perform(listing_id, image_paths)
    listing = Listing.find(listing_id)

    if listing.images.any?
      listing.images.each_with_index do |image, index|
        uploaded_image = Cloudinary::Uploader.upload(image_paths[index])
        image.url = uploaded_image["url"]
        image.file_name = uploaded_image["original_filename"]
      end

      listing.save
    end
  end
end