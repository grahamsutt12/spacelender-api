class Api::V1::UsersController < ApplicationController
  before_filter :authenticate, :except => [:create, :show, :confirm_email]


  api :GET, '/v1/users/:user_slug', "Show user profile."
  description "Below is an example of an expected response. Typically the user's profile image's caption will be null, as there is no real reason to have it."
  example User.example_response
  def show
    render :json => User.find(params[:id])
  end



  api :POST, '/v1/users', "Create a new user. They will not be active until the user confirms through email."
  description "Below is an example of how a request to create a new user should be formatted. Notice that you must also include email and password confirmations."
  example User.example_request
  param :user, Hash, :required => true do
    param :first_name, String, "The new user's first name.", :required => true
    param :last_name, String, "The new user's last name.", :required => true
    param :email, String, "The new user's email. Must be unique. You will get an error response if the email is already in use.", :required => true
    param :email_confirmation, String, "The new user's email typed again. This does not get persisted. It is just to make sure the user has accurately enetered his or her information.", :required => true
    param :password, String, "The new user's password.", :required => true
    param :password_confirmation, String, "The new user's password typed again. This does not get persisted. It is just to make sure the user has accurately enetered his or her information.", :required => true
    param :tos, [true], "The Terms of Service agreement. Must be true or will respond with an error.", :required => true
    param :image_attributes, Hash, :required => true do
      param :path, String, "The absolute file path to the location of the profile image on your local machine for the new user.", :required => true
    end
  end
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
  description "Updating a user is almost exactly the same as creating one. Just make a PUT request instead and specify the user's slug in the URL."
  see "users#create", "How to create a New User request. Click the link to see an example on how to build your JSON request."
  def update
    if @current_user.update(user_params)
      render :json => user, :status => :ok
    else
      render :json => {:errors => user.errors}, :status => :unprocessable_entity
    end
  end


  api :DELETE, '/v1/users/:user_slug', "Make user account inactive."
  description "This request will make the user \"inactive\", it does not completely delete the user. This is done on purpose in case a user wishes to return to SpaceLender, then they can reactivate their account rather than set it up all over again. Below is an example of type of response you could expect for successfully or unsuccessfully deactivating the user account."
  example JSON.pretty_generate({"success": "The user has successfully been deleted."})
  example JSON.pretty_generate({"errors": "User does not exist."})

  def destroy
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
  description "This request gets sent as a full URL to the new user's email address. When they click on it, their account will be activated. This will also respond with the user JSON object."

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
