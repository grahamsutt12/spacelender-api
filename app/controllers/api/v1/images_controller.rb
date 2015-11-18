class Api::V1::ImagesController < ApplicationController

  ##
  # This controller is polymorphic between the User
  # and Listing models and accounts for these routes:
  #   - GET, PUT, PATCH, & DELETE => api/v1/listings/:listing_id/images/:id
  #   - GET, PUT, PATCH, & DELETE => api/v1/users/:user_id/images/:id
  ##

  before_filter :authenticate, :except => [:index, :show]
  before_action :set_object

  def index
    ##
    # Index will only display all of a listing's images
    ##
    render :json => @object.images, :status => :ok
  end

  def show
    ##
    # Show will only display a specified Listing's image
    ##
    image = @object.images.find(params[:id])
    render :json => image, :status => :ok
  end

  def update
    image = get_image_from_model(params[:id])

    if image.update(image_params)
      render :json => image, :status => :ok
    else
      render :json => {:errors => image.errors}, :status => :unprocessable_entity
    end
  end

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
