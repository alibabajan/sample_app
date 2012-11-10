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
	has_many :microposts, dependent: :destroy
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	# dependent: :destroy -> Ensuring that a user’s microposts are destroyed along with the user. 
	has_many :followed_users, through: :relationships, source: :followed
  	has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  	has_many :followers, through: :reverse_relationships, source: :follower	

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

	def feed
	    #Micropost.where("user_id = ?", id)
	    Micropost.from_users_followed_by(self)
	end

	def following?(other_user)
		relationships.find_by_followed_id(other_user.id)
	end

	def follow!(other_user)
		self.relationships.create!(followed_id: other_user.id)
	end

	def unfollow!(other_user)
		relationships.find_by_followed_id(other_user.id).destroy
	end


private

    def create_remember_token
    	#generate a secure random token to be used by session
        self.remember_token = SecureRandom.urlsafe_base64
    end	  						
end
