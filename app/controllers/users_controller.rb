class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # redirect to the user's profile page
      session[:user_id] = @user.id
      redirect_to @user, notice: "Thanks for signing up!"
    else
      # if the user doesn't save, render the new form again
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # update the user
    if @user.update(user_params)
      flash[:notice] = "User was successfully updated!"
      redirect_to @user
    else
      flash[:alert] = "Something went wrong. Check your form and try again."
      # if the user doesn't save, render the edit form again
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil 
    # if an admin deletes their own account, log them out, too but the seeion[:user_id] = nil is not working
    flash[:notice] = "User was successfully deleted!"
    redirect_to root_path, status: :see_other, notice: "User was successfully deleted!"
  end


  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def authorize_user!
    unless @user == current_user
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to root_path
    end
  end
end
