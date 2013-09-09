class FeedsController < ApplicationController
  before_filter :check_for_mobile, :only => [:index]
  before_filter :login_required
  
	def index
    @feeds = Feed.where(:user_id => current_user.id).order("created_at DESC")

    respond_to do | format |
      format.html
      format.js {render :layout => false}
    end
  end
end
