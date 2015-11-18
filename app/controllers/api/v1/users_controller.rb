class Api::V1::UsersController < ApplicationController
  before_filter :authenticate, :except => [:create, :show, :confirm_email]

  def show
    render :json => User.find(params[:id])
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

  def update
    user = User.find(params[:id])

    if user.update(user_params)
      render :json => user, :status => :ok
    else
      render :json => {:errors => user.errors}, :status => :unprocessable_entity
    end
  end

  def destroy
    ### 
    # This method makes the user inactive, it does not completely 
    # destroy the user. The user's data is needed for record keeping.
    ###

    user = User.find(params[:id])

    if user
      user.active = false
      user.auth_token = nil
      user.save!
      render :json => {"success": "The user has successfully been deleted."}, :status => :ok
    else
      render :json => {"errors": "User does not exist."}, :status => :unprocessable_entity
    end
  end

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
