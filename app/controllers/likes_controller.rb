class LikesController < ApplicationController
  def index
    user = User.find(params[:user_id])
    @likes = Like.find_all_by_user_id(user.id)
  end

  def create
    user = User.find(session[:user_id])
    chinchin = Chinchin.find(params[:chinchin_id])
    @chinchinId = params[:chinchin_id]
    user.like(chinchin)

    respond_to do | format |
      format.js {render :layout => false}
    end
  end
end
