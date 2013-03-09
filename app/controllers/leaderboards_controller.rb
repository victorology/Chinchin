class LeaderboardsController < ApplicationController
  def index
    user = current_user
    @chinchins = user.chinchins_in_leaderboard
    #@chinchins = user.people_in_leaderboard
  end
end
