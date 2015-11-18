class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  @current_user

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      @current_user = User.find_by(:auth_token => token)
    end
  end

  def require_admin
    if !@current_user.employee?
      render :json => {:errors => "Unauthorized"}, :status => :unauthorized
    end
  end
end
