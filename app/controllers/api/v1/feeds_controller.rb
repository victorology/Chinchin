class API::V1::FeedsController < API::V1::BaseController
  def index
    @feeds = Feed.where(:user_id => @current_user.id).order("created_at DESC")
  end
end