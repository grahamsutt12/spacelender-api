class UserImageUploadWorker
  include Sidekiq::Worker

  def perform(user_id, image_path)
    user = User.find(user_id)

    if user.image
      uploaded_image = Cloudinary::Uploader.upload(image_path, :transformation => [:width => 300, :height => 300, :crop => :thumb, :gravity => :face, :radius => :max])
      user.image.url = uploaded_image["url"]
      user.image.file_name = uploaded_image["original_filename"]
      user.save
    end
  end
end