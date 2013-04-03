class ChinchinsController < ApplicationController
	# Render mobile or desktop depending on User-Agent for these actions.
  before_filter :check_for_mobile, :only => [:index, :show]

  def index
    @user = current_user
    respond_to do | format |
      format.js {render :layout => false}
      format.html
    end
  end

	def show
		@chinchin = Chinchin.find(params[:id])
    @photos = @chinchin.profile_photos || []

    respond_to do | format |
      format.js {render :layout => false}
      format.html
    end
    #@likes = @chinchin.likes
  end

  def profile_photos
    @chinchin = Chinchin.find(params[:id])
    @photos = @chinchin.profile_photos || []

    respond_to do | format |
      format.js {render :layout => false}
    end
  end
end