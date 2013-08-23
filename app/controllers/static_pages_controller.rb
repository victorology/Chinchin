class StaticPagesController < ApplicationController
  # Render mobile or desktop depending on User-Agent for these actions.
  before_filter :check_for_mobile, :only => [:home]

  def home
    if current_user
      if mobile_device?
        redirect_to "/m#browse"
      else
        redirect_to "/chinchins"
      end
    # else
    #   if mobile_device?
    #     redirect_to "/m"
    #   end
    end
  end

  # This controller is for the download page
  def download
    # This code is added so the template does not use application.html.erb
    render :layout => false
  end

  # This controller is for a Facebook canvas app
  def fb4pp01
    # This code is added so the template does not use application.html.erb
    render :layout => false
  end

  # This controller is for the Privacy Policy
  def privacy_policy
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

  def update_chinchin_photoscount
    Chinchin.delay.update_photo_count

    render :text => "update photo count..."
  end

  def update_chinchin_photos_where_no_photos
    Chinchin.all.each do |chinchin|
      if chinchin.photos.count == 0
        chinchin.delay.fetch_profile_photos
      end
    end

    render :text => "fetching..."
  end

  def stats
    @total = Chinchin.all.count
    @current = Chinchin.find(:all, :conditions => {:photo_count => nil}).count
    @progressed_data = @total - @current
    @progressed_time = Time.now - Delayed::Job.first.created_at
    @progressed_ratio = ((@progressed_data / @total.to_f) * 100).round(2)
  end

  def push_test
    user = User.find(params[:userId])
    message = params[:message]
    UrbanairshipWrapper.send([user], message)
    render :nothing => true
  end
end
