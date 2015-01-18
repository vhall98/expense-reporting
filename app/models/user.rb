class User < ActiveRecord::Base
  attr_accessor :password
  before_save :encrypt_password
  after_save :clear_password

  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i
  #EMAIL_REGEX = /A[w+-.]+@[a-zd-.]+.[a-z]+z/i
  validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  validates :password, :presence => true, :confirmation => true, :length => { :minimum => 6, :maximum => 20 }, :on => :create
  
  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.encrypted_password = BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def clear_password
    self.password = nil
  end
  
  def self.authenticate(username_or_email="", login_password="")
    user = nil
    email_regex=EMAIL_REGEX.match(username_or_email)

    if EMAIL_REGEX.match(username_or_email)
      user = User.where("email = ?", username_or_email).first
    else
      user = User.where("username = ?", username_or_email).first
    end

    if !user.nil? && user.encrypted_password != BCrypt::Engine.hash_secret(login_password, user.salt)
      user = nil
    end
    user
  end
    
end
