class ChinchinsController < ApplicationController
	# Render mobile or desktop depending on User-Agent for these actions.
  before_filter :check_for_mobile, :only => :show

	def show
		@chinchin = Chinchin.find(params[:id])
    @photos = @chinchin.photos
    @likes = @chinchin.likes
  end

  def profile_photos
    @chinchin = Chinchin.find(params[:id])
    @photos = @chinchin.photos

    respond_to do | format |
      format.js {render :layout => false}
    end
  end
end