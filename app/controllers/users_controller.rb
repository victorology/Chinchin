class UsersController < ApplicationController
  before_filter :login_required

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

  def register_device_token
    device_token = params[:device_token]
    user = current_user
    user.device_token = device_token
    if user.save
      Urbanairship.register_device(device_token)
    end
    render :text => current_user.id.to_s
  end

  def register_apid
    apid = params[:apid]
    user = current_user
    user.apid = apid
    if user.save
      Urbanairship.register_device(apid, :provider => :android)
    end
    render :text => current_user.id.to_s
  end
end