class LikesController < ApplicationController
  # Render mobile or desktop depending on User-Agent for these actions.
  before_filter :check_for_mobile, :only => [:index, :create, :destroy]
  before_filter :login_required

  def index
    @user = current_user # Added by Victor don't know if this is right
    @likes = Like.where(:user_id => @user.id).order("created_at DESC")

    respond_to do | format |
      format.html
      format.js {render :layout => false}
    end
  end

  def create
    @chinchinId = params[:chinchin_id]
    chinchin = Chinchin.find(@chinchinId)
    if Like.find_by_user_id_and_chinchin_id(current_user.id, @chinchinId).nil?
      current_user.like(chinchin)
    end

    respond_to do | format |
      format.js {render :layout => false}
    end
  end

  def destroy
    chinchin_id = params[:chinchin_id]
    chinchin = Chinchin.find(chinchin_id)
    like = Like.find_by_user_id_and_chinchin_id(current_user.id, chinchin_id)
    if not like.nil?
      like.destroy
    end

    respond_to do | format |
      format.js {render :layout => false}
    end
  end
end
