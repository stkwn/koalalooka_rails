class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, except: [:destroy]

  def new
    
  end

  def create
    @user = User.find_by(email: params[:email].downcase)
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "You have successfully logged in"
      redirect_to @user,  notice: "Welcome back, #{@user.name}"
    else
      flash.now[:alert] = "Invalid email/password combination!"
      render :new, status: :unprocessible_entity
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have successfully logged out"
    redirect_to root_path
  end

end
