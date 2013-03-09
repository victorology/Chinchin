class UsersController < ApplicationController
  # This controller is for the user index
  def index
  	@users = User.all
  end

  # This controller is for a detailed user profile
  def show
    userId = session[:user_id]
    if userId.to_s != params[:id]
      render :text => "Invalid access"
    end
    @user = User.find(params[:id])
  end
end