class Api::V1::SessionsController < ApplicationController

  api :POST, "/v1/sessions", "Logs the user in."
  description "This call will return the Auth Token needed to authenticate requests."
  example JSON.pretty_generate({"session": {"email": "johndoe@example.com", "password": "secret123"}})
  param :session, Hash do
    param :email, String, "The email for the user logging in.", :required => true
    param :password, String, "The password for the user logging in. Password must be at least 8 characters long.", :required => true
  end

  def create
    if user = User.authenticate(params[:session][:email], params[:session][:password])
      if user.auth_token.nil? || user.auth_token.blank?
        if user.active && user.confirm_token.nil?
          user.generate_auth_token
          user.save

          render :json => user, :meta => {:auth_token => user.auth_token}, :status => :ok
        else
          render :json => {"errors": "Account is not active. If you're new, you can activate your account by visitng your email at #{user.email}."}, :status => :unauthorized
        end
      else
        render :json => {"errors": "User is already logged in."}, :status => :unauthorized
      end
    else
      render :json => {"errors": "Invalid email or password."}, :status => :unprocessable_entity
    end
  end



  api :DELETE, "/v1/sessions/:auth_token", "Logs the user out. This will nilify the user's Authorization token."
  description "This action returns a \"204 No Content\" header. No response will be generated."

  def destroy
    user = User.find_by_auth_token(params[:id])
    user.auth_token = nil
    user.save
    head :no_content
  end

  private
  def excluded_user_params
    # Allow client to retrieve auth_token
    [:id, :password_salt, :password, :confirm_token]
  end
end
