class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  @current_user


  ##
  # Authenticates an authorization token sent by the client. This is
  # used before many controller actions, but not all. 
  ##
  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      @current_user = User.find_by(:auth_token => token)
    end
  end


  ##
  # This method is used to restrict certain controller actions to require
  # administrator access.
  ##
  def require_admin
    if !@current_user.admin?
      render :json => {:errors => "Unauthorized"}, :status => :unauthorized
    end
  end


  ##
  # This method is used to restrict certain controller actions to require at 
  # least employee access. This means administrators will also be allowed access
  # to whatever employees can access. 
  ##
  def require_employee
    if !@current_user.employee? || !@current_user.admin?
      render :json => {:errors => "Unauthorized"}, :status => :unauthorized
    end
  end

end
