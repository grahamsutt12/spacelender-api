class Api::V1::ImagesController < ApplicationController

  ##
  # This controller is polymorphic between the User
  # and Listing models and accounts for these routes:
  #   - GET, PUT, PATCH, & DELETE => api/v1/listings/:listing_id/images/:id
  #   - GET, PUT, PATCH, & DELETE => api/v1/users/:user_id/images/:id
  ##

  before_filter :authenticate, :except => [:index, :show]
  before_action :set_object

  api :GET, '/v1/listings/:listing_slug/images', "Show all images for a specific listing."
  example Image.example_response("index")
  description "This request only returns images for listings, not users. Below is an example of the response."
  def index
    ##
    # Index will only display all of a listing's images
    ##
    render :json => @object.images, :status => :ok
  end



  api :GET, '/v1/listings/:listing_slug/images/:id', "Show a specific image for a specific listing."
  example Image.example_response("show")
  description "This request only returns an image from a listing, not from a user. Below is an example of the response."
  def show
    ##
    # Show will only display a specified Listing's image
    ##
    image = @object.images.find(params[:id])
    render :json => image, :status => :ok
  end


  # api :PUT, '/v1/users/:user_slug/images/:id', "Update user's profile image."
  # param :user_slug, String, "The user's slug."
  # param :id, :number, "The image's id."

  api :PUT, '/v1/listings/:listing_slug/images/:id', "Update a specific image for a specific listing."
  example Image.example_request
  description "The only thing about an image that can be updated is its caption. To swap a photo, you have to first drop a picture and then create a new one."
  meta :important => "To update a users image, use this request:   PUT /v1/users/:user_slug/images/:id"
  see "images#destroy", "Deleting an image."
  param :image, Hash do
    param :caption, String, "The image's caption."
  end
    
  def update
    image = get_image_from_model(params[:id])

    if image.update(image_params)
      render :json => image, :status => :ok
    else
      render :json => {:errors => image.errors}, :status => :unprocessable_entity
    end
  end


  api :DELETE, '/v1/listings/:listing_slug/images/:id', "Delete a specific listing's image."
  example JSON.pretty_generate({"success" => "Image was succesfully deleted."})
  example JSON.pretty_generate({"errors" => "Image could not be deleted."})
  description "Below are the expected responses for successfully or unsuccessfully deleting an image."
  meta :important => "To delete a users image, use this request:   DELETE /v1/users/:user_slug/images/:id"
  def destroy
    image = get_image_from_model(params[:id])

    if image.destroy
      render :json => {"success" => "Image was succesfully deleted."}, :status => :ok
    else
      render :json => {"errors" => "Image could not be deleted."}, :status => :unprocessable_entity
    end
  end
  

  private
  def image_params
    params.require(:image).permit(:id, :path, :caption)
  end

  def get_image_from_model(id)
    if @object.class.name == "Listing"
      image = @object.images.find(id)
    elsif @object.class.name == "User"
      image = @object.image
    end

    image
  end

  def set_object
    klass = [User, Listing].detect{|c| params["#{c.name.underscore}_id"]}
    @object = klass.find(params["#{klass.name.underscore}_id"])
  end
end
