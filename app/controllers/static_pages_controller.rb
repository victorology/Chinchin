class StaticPagesController < ApplicationController
  def home
  end

  def users
  	@user = User.all
  end

  def profile
  	@user = User.find(params[:id])
  end

  # This controller is for a Facebook canvas app
  def fb4pp01
  	# This code is added so the template does not use application.html.erb
  	render :layout => false
  end
end
