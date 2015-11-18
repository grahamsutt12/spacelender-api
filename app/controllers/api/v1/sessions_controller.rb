class Api::V1::SessionsController < ApplicationController

  def create
    if user = User.authenticate(params[:session][:email], params[:session][:password])
      if user.auth_token.nil? || user.auth_token.blank?
        if user.active && user.confirm_token.nil?
          user.generate_auth_token
          user.save
          render :json => user, :except => excluded_user_params, :status => :ok
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
