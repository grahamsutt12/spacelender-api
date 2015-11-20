class Api::V1::ListingsController < ApplicationController
  before_filter :authenticate, :except => [:index, :show]

  api :GET, '/v1/listings', "Show all listings. Does not require authentication."
  description "Returns an array of all listing objects."
  see "listings#show", "To see the individual format of a single listing."

  def index
    render :json => Listing.all, :status => :ok
  end




  api :GET, '/v1/listings/:listing_slug', "Show a specific listing. Does not require authentication."
  description "Below is an example of the expected response. Sometimes, the images immediately after creation will result in null. This is expected as images that are uploaded to the server are then uploaded to the Cloudinary bucket IN THE BACKGROUND where they are transformed and stored."
  example Listing.example_response

  def show
    listing = Listing.find(params[:id])
    render :json => listing, :status => :ok
  end




  api :POST, '/v1/listings', "Create a new listing."
  description "Below is the format on how a new listing should be sent."
  example Listing.example_request
  param :listing, Hash do
    param :name, String, "The name of the listing.", :required => true
    param :description, String, "The description of the listing."
    param :images_attributes, Array, "The images for the listing." do
      param :path, String, "The absolute path of the image from your local machine.", :required => true
      param :caption, String, :desc => "A caption for the image.", :required => true
    end
    param :location_attributes, Hash, "The full address of the loation of the listing.", :required => true do
      param :address, String, "The address for the location.", :required => true
      param :city, String, "The city for the location.", :required => true
      param :state, String, "The state for the location.", :required => true
      param :country, String, "The country for the location.", :required => true
      param :zip, String, "The zip/postal code for the location.", :required => true
    end
    param :rates_attributes, Array, "The rates for the listing.", :required => true do
      param :amount, :number, "The amount for the specific type or rate.", :required => true
      param :time_type, ["hourly", "daily", "weekly", "monthly"], "The type of time period the rate amount reflects.\ne.g. $12 per hour, $200 per week, etc...", :required => true
    end
  end

  def create
    listing = @current_user.listings.build(listing_params)
    image_paths = []

    # The images' paths will be passed as an array for Cloudinary upload
    if listing.images.any?
      listing.images.each_with_index do |image, index|
        image_paths[index] = image.path
      end
    end

    if listing.save
      ListingImageUploadWorker.perform_async(listing.id, image_paths)
      render :json => listing, :status => :ok
    else
      render :json => {:errors => listing.errors}, :status => :unprocessable_entity
    end
  end




  api :PUT, '/v1/listings/:listing_slug', "Update a listing."
  see "listings#create", "Update and Create use the same JSON format. Refer to the listings#create example"

  def update
    listing = @current_user.listings.find(params[:id])

    if listing.update(listing_params)
      render :json => listing, :status => :ok
    else
      render :json => {:errors => listing.errors}, :status => :unprocessable_entity
    end
  end





  api :DELETE, '/v1/listings/:listing_slug', "Delete a listing."
  description "Below is an example of the expected response either when a listing successfully or unsuccessfully deleted."
  example JSON.pretty_generate({"success": "The listing was succesfully deleted."})
  example JSON.pretty_generate({"errors": "The listing could not be deleted."})

  def destroy
    listing = @current_user.listings.find(params[:id])

    if listing.destroy
      render :json => {"success": "The listing was succesfully deleted."}, :status => :ok
    else
      render :json => {"errors": "The listing could not be deleted."}, :status => :unprocessable_entity
    end
  end

  private
  def listing_params
    params.require(:listing).permit(:name, :description, images_attributes: [:id, :path, :caption], rates_attributes: [:id, :amount, :time_type], location_attributes: [:address, :city, :state, :country, :zip])
  end
end
