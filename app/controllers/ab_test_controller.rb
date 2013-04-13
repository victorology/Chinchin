class AbTestController < ApplicationController
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
end
