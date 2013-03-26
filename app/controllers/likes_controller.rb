class LikesController < ApplicationController
  # Render mobile or desktop depending on User-Agent for these actions.
  before_filter :check_for_mobile, :only => [:index]

  def index
    @user = current_user # Added by Victor don't know if this is right
    user = User.find(params[:user_id])
    @likes = Like.find_all_by_user_id(user.id)
  end

  def create
    chinchin = Chinchin.find(params[:chinchin_id])
    @chinchinId = params[:chinchin_id]
    current_user.like(chinchin)

    respond_to do | format |
      format.js {render :layout => false}
    end
  end
end
