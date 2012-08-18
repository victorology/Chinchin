class StaticPagesController < ApplicationController
  def home
  end

  # This controller is for the user index
  def users
  	@user = User.all
  end

  # This controller is for the user profile
  def profile
  	@user = User.find(params[:id])
  end

  # This controller is for a Facebook canvas app
  def fb4pp01
  	# This code is added so the template does not use application.html.erb
  	render :layout => false
  end

  def fbindex
      app_secret = '035385fe9e7db60eba187ab83fb27cb6'
      @signed_request = FBGraph::Canvas.parse_signed_request(app_secret, params[:signed_request])
  end
end
