class LeaderboardsController < ApplicationController
  before_filter :check_for_mobile, :only => [:index]
  before_filter :login_required

  def index
    @leaders = current_user.people_in_leaderboard

    respond_to do | format |
      format.js {render :layout => false}
      format.html
    end
  end
end
