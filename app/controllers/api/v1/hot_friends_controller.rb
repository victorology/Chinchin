class API::V1::HotFriendsController < API::V1::BaseController
  def index
    @leaders = @current_user.people_in_leaderboard
  end
end