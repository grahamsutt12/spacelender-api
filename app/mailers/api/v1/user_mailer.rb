class Api::V1::UserMailer < ApplicationMailer
  default from: "SpaceLender"

  ##
  # This email sends the Activation Code needed for newly registered users
  # to activate their accounts. 
  ##
  def sign_up_confirmation(user)
    @user = user
    mail(:to => @user.email, 
         :subject => "Confirm and Activate Your Account",
         :body => "Hi #{@user.first_name}, \n\n Thanks for signing up with SpaceLender.
                  Please click the link below to activate your account: \n
                  #{confirm_email_api_v1_user_url(@user.confirm_token)}"
    )
  end
end
