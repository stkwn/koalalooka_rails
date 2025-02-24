class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :authenticate_user!

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate_user!
    unless current_user
      flash[:alert] = "You need to sign in first!"
      redirect_to login_path
    end
  end
end
