class Api::V1::ListingsController < ApplicationController
  before_filter :authenticate, :except => [:show]

  def index
    render :json => Listing.all, :status => :ok
  end

  def show
    listing = Listing.find(params[:id])
    render :json => listing, :status => :ok
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

  def update
    listing = Listing.find(params[:id])

    if listing.update(listing_params)
      render :json => listing, :status => :ok
    else
      render :json => {:errors => listing.errors}, :status => :unprocessable_entity
    end
  end

  def destroy
    listing = Listing.find(params[:id])

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
