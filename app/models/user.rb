class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, :use => [:slugged, :finders]

  before_create :generate_confirmation_token, :encrypt_password

  enum :role => [:normal, :employee, :admin]

  has_many :reports
  has_many :listings, :dependent => :destroy
  has_many :sent_messages, :class_name => "Message", :foreign_key => "sender_id"
  has_many :received_messages, :class_name => "Message", :foreign_key => "receiver_id"
  has_one :image, :as => :imageable, :dependent => :destroy

  validates :first_name, presence: true, length: { minimum: 2, maximum: 30 }
  validates_format_of :first_name, :with => /\A[^\(\)0-9]*\z/
  validates :last_name, presence: true, length: { minimum: 2, maximum: 30 }
  validates_format_of :last_name, :with => /\A[^\(\)0-9]*\z/
  validates :email, presence: true, confirmation: true, uniqueness: true
  validates_format_of :email, :with => /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/
  validates :password, confirmation: true, presence: true, length: { minimum: 8, maximum: 20 }, :on => :create
  validates :publishable_key, :uniqueness => true, :allow_blank => true
  validates :merchant_account, :uniqueness => true, :allow_blank => true
  validates :access_code, :uniqueness => true, :allow_blank => true
  validates :tos, :acceptance => {:accept => true, :message => "You must accept the Terms of Service and Stripe Connect Platform Agreement" }

  accepts_nested_attributes_for :image

  attr_accessor :password_confirmation, :email_confirmation

  def encrypt_password
    self.password_salt = BCrypt::Engine.generate_salt
    self.password = BCrypt::Engine.hash_secret(password, self.password_salt)
  end

  def self.authenticate(email, password)
    user = User.where(email: email).first

    if user && user.password == BCrypt::Engine.hash_secret(password, user.password_salt)
      return user
    else
      return nil
    end
  end

  def messages
    Message.where("sender_id = ? OR receiver_id = ?", self.slug, self.slug)
  end

  def email_activate
    self.active = true
    self.confirm_token = nil
    save!(:validate => false)
  end

  def slug_candidates
    [
      [:first_name, rand(100000..999999)],
      [:first_name, rand(100000..999999)],
      [:first_name, rand(100000..999999)]
    ]
  end

  def generate_auth_token
    begin
      self.auth_token = SecureRandom.hex
    end while self.class.exists?(:auth_token => auth_token)
  end

  protected
  def generate_confirmation_token
    self.confirm_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(confirm_token: random_token)
    end
  end
end
