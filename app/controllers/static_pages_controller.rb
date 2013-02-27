class StaticPagesController < ApplicationController
  def home
    if current_user
      redirect_to "/user/#{current_user.id}/chinchin"
    end
  end

# This controller is for a Facebook canvas app
  def fb4pp01
    # This code is added so the template does not use application.html.erb
    render :layout => false
  end

  def make_chinchin
    @user = User.find(params[:id])
    @user.delay.add_friends_to_chinchin

    render :text => 'making...'
  end
end