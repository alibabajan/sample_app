# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
	attr_accessible :name, :email, :password, :password_confirmation
	
	#a Rails method: As long as there is a password_digest column 
	#in the database, adding this one method to our model gives us
	# a secure way to create and authenticate new users.
	# this will encrypt the password saved to the database and provides
	# authenticate() method to the user object
	has_secure_password

    #field value presence and length validations
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i  #valid email format
	validates :email, presence: true,  format: { with: VALID_EMAIL_REGEX },
	 		  						uniqueness: { case_sensitive: false }
	validates :password, presence: true, length: { minimum: 6 }	 
	validates :password_confirmation, presence: true		  						

#callback to force Rails to downcase 
#the email attribute before saving the user to the database
#to ensure uniqueness
before_save { |user| user.email = email.downcase }	
before_save :create_remember_token 	

private

    def create_remember_token
    	#generate a secure random token to be used by session
      self.remember_token = SecureRandom.urlsafe_base64
    end	  						
end
