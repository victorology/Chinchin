class StaticPagesController < ApplicationController
  # Render mobile or desktop depending on User-Agent for these actions.
  before_filter :check_for_mobile, :only => :profile

  def home
    if current_user
      redirect_to "/user/#{current_user.id}/chinchin"
    end
  end

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

  # This controller is for a Facebook canvas app
  def fb4pp01
  	# This code is added so the template does not use application.html.erb
  	render :layout => false
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

  def make_chinchin
    @user = User.find(params[:id])
    @user.delay.add_friends_to_chinchin

    render :text => 'making...'
  end

end