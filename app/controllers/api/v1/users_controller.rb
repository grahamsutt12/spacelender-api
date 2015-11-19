class Api::V1::UsersController < ApplicationController
  before_filter :authenticate, :except => [:create, :show, :confirm_email]


  api :GET, '/v1/users/:user_slug', "Show user profile."
  param :user_slug, String, "The user's slug.", :required => true
  def show
    render :json => User.find(params[:id])
  end


  api :POST, '/v1/users', "Create a new user. They will not be active until the user confirms through email."
  def create
    user = User.new(user_params)

    if user.save
      UserImageUploadWorker.perform_async(user.id, user.image.path)
      Api::V1::UserMailer.sign_up_confirmation(user).deliver_now
      render :json => user, :status => :ok
    else
      render :json => {:errors => user.errors}, :status => :unprocessable_entity
    end
  end


  api :PUT, '/v1/users/:user_slug', "Update information about an existing user."
  param :user_slug, String, "The user's slug.", :required => true
  def update
    user = User.find(params[:id])

    if user.update(user_params)
      render :json => user, :status => :ok
    else
      render :json => {:errors => user.errors}, :status => :unprocessable_entity
    end
  end


  api :DELETE, '/v1/users/:user_slug', "Make user account inactive. This does not delete the user completely."
  param :user_slug, String, "The user's slug.", :required => true
  def destroy
    ### 
    # This method makes the user inactive, it does not completely 
    # destroy the user. The user's data is needed for record keeping.
    ###

    if @current_user
      @current_user.active = false
      @current_user.auth_token = nil
      @current_user.save!
      render :json => {"success": "The user has successfully been deleted."}, :status => :ok
    else
      render :json => {"errors": "User does not exist."}, :status => :unprocessable_entity
    end
  end


  api :GET, '/v1/users/:confirm_token/confirm_email', "Makes a user account active."
  param :confirm_token, String, "The user's confirmation token. It is generated immediately after the user has been created for the first time.", :required => true
  def confirm_email
    user = User.find_by_confirm_token(params[:id])

    if user
      user.email_activate
      ConfigureStripeWorker.perform_async(user.id)
      render :json => user, :status => :ok
    else
      render :json => {"errors": "User does not exist."}, :status => :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :email_confirmation, :password, :password_confirmation, :role, :first_name, :last_name, image_attributes: [:id, :path])
  end
end
