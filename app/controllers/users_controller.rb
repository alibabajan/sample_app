class UsersController < ApplicationController
  def new
  	@user = User.new
  end
  def show
    @user = User.find(params[:id])
  end

  def create
  	#submitting the form results in 
  	#a user hash with attributes corresponding to the submitted values
    @user = User.new(params[:user])
    if @user.save
      # Handle a successful save.
      sign_in @user #automatically sign in user after signup
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
end
