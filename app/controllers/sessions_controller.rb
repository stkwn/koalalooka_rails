class SessionsController < ApplicationController

  def new
    
  end

  def create
    @user = User.find_by(email: params[:email].downcase)
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:success] = "You have successfully logged in"
      redirect_to user,  notice: "Welcome back, #{user.name}"
    else
      render :new, status: :unprocessible_entity
    end
  end

  def destroy
    
  end

end