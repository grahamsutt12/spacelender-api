class UserImageUploadWorker
  include Sidekiq::Worker

  def perform(user_id, image_path)
    user = User.find(user_id)

    if user.image
      uploaded_image = Cloudinary::Uploader.upload(image_path, :eager => [{ :crop => :thumb, :gravity => :face }])
      user.image.url = uploaded_image["url"]
      user.image.file_name = uploaded_image["original_filename"]
      user.save
    end
  end
end