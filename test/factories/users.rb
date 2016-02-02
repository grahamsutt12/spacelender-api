FactoryGirl.define do
  factory :user, :class => "User" do
    first_name "Graham"
    last_name "Sutton"
    email "grahamsutton12@gmail.com"
    email_confirmation "grahamsutton12@gmail.com"
    password "supercool"
    password_confirmation "supercool"
    merchant_account "some_uid_123"
    publishable_key "some_pb_key_123"
    access_code "some_access_code_123"
  end

  # Second User is for testing against the uniqueness of Stripe credentials
  factory :second_user, :class => "User" do
    first_name "Mikey"
    last_name "Mikerson"
    email "mikeymikerson@gmail.com"
    email_confirmation "mikeymikerson@gmail.com"
    password "totallycool"
    password_confirmation "totallycool"
    merchant_account "another_uid"
    publishable_key "another_pb_key"
    access_code "another_access_code"
  end
end