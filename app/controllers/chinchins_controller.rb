class ChinchinsController < ApplicationController
	# Render mobile or desktop depending on User-Agent for these actions.
  before_filter :check_for_mobile, :only => [:index, :show, :under_construction]
  before_filter :login_required, :except => [:under_construction]

  def index
    @user = current_user
    heart = @user.currency(Currency::HEART)
    heart.recalculate
    if not heart.is_available
      @no_more_heart = true
    end

    respond_to do | format |
      format.js {render :layout => false}
      format.html
    end
  end

	def show
    @user = current_user
		@chinchin = User.find(params[:id])
    @photos = @chinchin.profile_photos || []

    respond_to do | format |
      format.js {render :layout => false}
      format.html
    end
    #@likes = @chinchin.likes
  end

  def profile_photos
    @chinchin = User.find(params[:id])
    @photos = @chinchin.profile_photos || []

    respond_to do | format |
      format.js {render :layout => false}
    end
  end

  def under_construction
    render :layout => false
  end
end