require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = FactoryGirl.build(:user)
  end

  test "a first name should be provided" do
    user = FactoryGirl.build(:user, :first_name => nil)
    assert !user.valid?, "The user was saved without a first name."
  end

  test "a last name should be provided" do
    user = FactoryGirl.build(:user, :last_name => nil)
    assert !user.valid?, "The user was saved without a last name."
  end

  test "the user's first name should not be less than 2 letters in length" do
    user = FactoryGirl.build(:user, :first_name => "x")
    assert !user.valid?, "The user was saved with a one letter first name."
  end

  test "the user's last name should not be less than 2 letters in length" do
    user = FactoryGirl.build(:user, :last_name => "x")
    assert !user.valid?, "The user was saved with a one letter last name."
  end

  test "the user's first and last name shoud not be more than 30 letters in length" do
    user = FactoryGirl.build(:user, :first_name => "x" * 31)
    assert !user.valid?, "The user was saved with a >30 length first name: #{user.first_name}"

    user = FactoryGirl.build(:user, :last_name => "x" * 31)
    assert !user.valid?, "The user was saved with a >30 length last name: #{user.last_name}"
  end

  test "the user's first name is saved at an acceptable length" do
    user = FactoryGirl.build(:user, :first_name => "Graham")
    assert user.valid?, "The user was not saved even though an acceptable length first name was provided."
  end

  test "the user's last name is saved at an acceptable length" do
    user = FactoryGirl.build(:user, :last_name => "Sutton")
    assert user.valid?, "The user was not saved even though an acceptable length last name was provided."
  end

  test "there should be no numbers in the first or last name" do
    user = FactoryGirl.build(:user, :first_name => "graham6")
    assert !user.valid?, "The user was saved with a number in the first name."

    user = FactoryGirl.build(:user, :last_name => "graham372")
    assert !user.valid?, "The user was saved with a number in the last name."
  end

  test "the user's password should not be blank" do
    user = FactoryGirl.build(:user, :password => nil)
    assert !user.valid?, "The user was saved with blank password."
  end

  test "the user's password should be between 8 and 20 characters" do
    user = FactoryGirl.build(:user, :password => "x" * 7)
    assert !user.valid?, "The user was a saved with a password less than the minimum number of chracters: '#{user.password}'"

    user = FactoryGirl.build(:user, :password => "x" * 21)
    assert !user.valid?, "The user was a saved with a password more than the maximum number of chracters: '#{user.password}'"

    user = FactoryGirl.build(:user, :password => "abcdef123", :password_confirmation => "abcdef123")
    assert user.valid?, "The user was not saved although they provided an acceptable password length."
  end

  test "the user's password and password confirmation should match" do
    user = FactoryGirl.build(:user, :password => "abcdef123", :password_confirmation => "123abcdef")
    assert !user.valid?, "The user was saved with mismatching passwords."

    user = FactoryGirl.build(:user, :password => "abcdef123", :password_confirmation => "abcdef123")
    assert user.valid?, "The user was not saved although they provided matching passwords."
  end

  test "the user's password should be encrypted on create" do
    user = FactoryGirl.build(:user)
    password_before_encryption = user.password
    user.save
    encrypted_password = user.password
    assert_not_equal password_before_encryption, encrypted_password, "The password was not encypted upon user creation."
  end

  test "the user's password should not be re-encrypted (it should never change) after an update" do
    user = FactoryGirl.create(:user)
    user.first_name = "Mike"
    current_encrypted_password = user.password
    user.save
    password_after_update = user.password
    assert_equal current_encrypted_password, password_after_update, "The encrypted password changed. It was probably re-encrypted after updating the user."
  end

  test "the user's role should be defaulted to 'normal' upon registration" do
    user = FactoryGirl.create(:user)
    assert_equal "normal", user.role, "The user's role was defaulted to '#{user.role}' upon registration."
  end

  test "the user's first name should also be in their slug" do
    user = FactoryGirl.create(:user)
    assert user.slug.include?(user.first_name.downcase), "The user's first name is not visible in their slug."
  end

  test "publishable keys should be unique across users" do
    user_1 = FactoryGirl.create(:user)
    user_2 = FactoryGirl.build(:second_user, :publishable_key => user_1.publishable_key)
    assert !user_2.valid?, "The user was able to save a duplicate publishable key."

    user_2 = FactoryGirl.build(:second_user)
    assert user_2.valid?, "The user was not saved although they provided a unique publishable key."
  end

  test "'merchant_account' column for Stripe accounts should be unique across users" do
    user_1 = FactoryGirl.create(:user)
    user_2 = FactoryGirl.build(:user, :merchant_account => user_1.merchant_account)
    assert !user_2.valid?, "The user was able to save a duplicate merchant_account token."

    user_2 = FactoryGirl.build(:second_user)
    assert user_2.valid?, "The user was not saved although they provided a unique uid."
  end

  test "access codes (for Stripe accounts) should be unique across users" do
    user_1 = FactoryGirl.create(:user)
    user_2 = FactoryGirl.build(:user, :access_code => user_1.access_code)
    assert_not user_2.valid?, "The user was able to save a duplicate access code."

    user_2 = FactoryGirl.build(:second_user)
    assert user_2.valid?, "The user was not saved although they provided a unique access code."
  end

  test "merchant_account column for stripe accounts can be blank" do
    user = FactoryGirl.build(:user, :merchant_account => nil)
    assert user.valid?, "The user is not being saved with a blank merchant_account."
  end

  test "publishable_key for stripe accounts can be blank" do
    user = FactoryGirl.build(:user, :publishable_key => nil)
    assert user.valid?, "The user is not being saved with a blank publishable key"
  end

  test "access_code for stripe accounts can be blank" do
    user = FactoryGirl.build(:user, :access_code => nil)
    assert user.valid?, "The user is not being saved with a blank access code"
  end

  test "the email should not be blank" do
    user = FactoryGirl.build(:user, :email => nil)
    assert !user.valid?, "The user was saved without an email."
  end

  test "the user's email should be in an acceptable email format" do
    users = []
    acceptable_formats = ["grahamsutt@gmail.com", "graham.sutt@gmail.com", "graham-sutt@gmail.com", "abc123@gmail.com"]
    
    acceptable_formats.each_with_index do |email, index|
      users[index] = FactoryGirl.build(:user, :id => "#{index + 1}", :email => email, :email_confirmation => email, :merchant_account => index, :access_code => index, :publishable_key => index)
      assert users[index].valid?, "#{email} was not saved as an acceptable format."
    end
  end

  test "the email and email confirmations provided should match" do
    user = FactoryGirl.build(:user, :email => "abc123@gmail.com", :email_confirmation => "123abc@gmail.com")
    assert !user.valid?, "The user was saved with mismatching passwords provided."

    user = FactoryGirl.build(:user, :email => "abc123@gmail.com", :email_confirmation => "abc123@gmail.com")
    assert user.valid?, "The user was not saved although they provided matching emails."
  end

  test "unacceptable email formats should not be saved" do
    users = []
    unacceptable_formats = ["grahamsuttgmail.com", "@gmail.com", ".com@grahams", "graham", "g?2#2342@as.om"]
    
    unacceptable_formats.each_with_index do |email, index|
      users[index] = FactoryGirl.build(:user, :id => "#{index + 1}", :email => email, :email_confirmation => email, :merchant_account => index, :access_code => index, :publishable_key => index)
      assert !users[index].valid?, "#{email} was saved as an acceptable format."
    end
  end

  test "email should be unique to one user" do
    user_1 = FactoryGirl.create(:user)
    user_2 = FactoryGirl.build(:second_user, :email => user_1.email)
    assert !user_2.valid?, "The user was saved with a duplicate email address."

    user_2 = FactoryGirl.build(:second_user)
    assert user_2.valid?, "The user was not saved even though they provided a unique email."
  end

  test "the email should match the email confirmation" do
    assert_equal @user.email, @user.email_confirmation, "The emails provided do not match."
  end
end
