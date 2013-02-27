class UsersController < ApplicationController
  # Render mobile or desktop depending on User-Agent for these actions.
  before_filter :check_for_mobile, :only => [:profile, :chinchin]

  # This controller is for the user index
  def users
  	@user = User.all
  end

  # This controller is for the user Chinchin list
  def chinchin
  	@user = User.find(params[:id])
  end

  # This controller is for a detailed user profile
  def profile
    @user = User.find(params[:id])
  end

  def like
    user = User.find(params[:userId])
    chinchin = Chinchin.find(params[:chinchinId])
    @chinchinId = params[:chinchinId]
    user.like(chinchin)

    respond_to do | format |
      format.js {render :layout => false}
    end
  end
end