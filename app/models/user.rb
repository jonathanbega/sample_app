class User < ActiveRecord::Base
  #makes sure that before saving the user, the email becomes lowercase
  before_save { self.email = email.downcase }
  
  #Creates a session token when sign in is "created"
  before_create :create_remember_token

  #makes sure name is present with a length of no more than 50 during signup
  validates(:name, presence: true, length: {maximum: 50})

  #During signup, makes sure email is there, has a valid form, is unique* and case insensitive
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-\.]+\.[a-z]+\z/i
  validates(:email, presence:true, format: { with: VALID_EMAIL_REGEX }, 
  	uniqueness: {case_sensitive: false})
  
  #make sure it has a secure password, ONE LINE!!! Must have a password_digest column in our table.
  has_secure_password
  validates(:password, length: { minimum: 6 })

  #generate a token
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  #encrypt tokens
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  #privately set the user's (self) encrypted token
  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end


end

#*Uniqueness not fully guaranteed here. Need to update the server too
#See /migrate/numbers_add_index_to_users_email to make uniqueness work on DB
