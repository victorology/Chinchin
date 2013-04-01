class StaticPagesController < ApplicationController
  def home
    if current_user
      if mobile_device?
        redirect_to "/m"
      else
        redirect_to "/chinchins"
      end
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

  def make_friendship
    users = User.all
    users.each do |user|
      user.delay.make_friendship
    end

    render :text => "making..."
  end

  def connect_users_with_chinchins
    User.all.each do |user|
      user.delay.connect_with_chinchin
    end

    render :text => "connecting..."
  end

  def fetch_chinchins_profile_photos
    Chinchin.all.each do |chinchin|
      chinchin.delay.fetch_profile_photos
    end

    render :text => "fetching..."
  end
end
