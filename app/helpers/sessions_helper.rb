module SessionsHelper

#We can use cookies as if it were a hash; each element in the cookie 
#is itself a hash of two elements, a value and an optional expires date
	def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    #Under the hood, using permanent causes Rails to set the expiration
    #to 20.years.from_now automatically.
    self.current_user = user
    #create current_user, accessible in both controllers and views, 
    #which will allow constructions such as <%= current_user.name %>
    #or "redirect_to current_user"
  end

  def current_user=(user)
    @current_user = user
  end

# a user is signed in if current_user is not nil
  def signed_in?
    !current_user.nil?
  end

#Finding the current user using the remember_token. 
    #the effect of ||= (“or equals”) executes the method 
    #only if @current_user is undefined
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])

end

def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

end
