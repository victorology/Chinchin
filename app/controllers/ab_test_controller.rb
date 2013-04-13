class AbTestController < ApplicationController
  USER, PASSWORD = 'chinchin', 'testchinchin!'

  before_filter :authentication_check

  def browse
    @user = User.find(6)

    prepare_for_mobile
    respond_to do | format |
      format.js
      format.html
    end
  end

  def detail
    @user = User.find(6)
    @chinchin = Chinchin.find(1036)
    @photos = @chinchin.profile_photos || []

    prepare_for_mobile
    respond_to do | format |
      format.js {render :layout => false}
      format.html
    end
  end

  def likes
    @user = User.find(6)
    @likes = Like.where(:user_id => @user.id).order("created_at DESC")

    prepare_for_mobile
    respond_to do | format |
      format.html
      format.js {render :layout => false}
    end
  end

  private
  def authentication_check
    authenticate_or_request_with_http_basic do |user, password|
      user == USER && password == PASSWORD
    end
  end
end
