class API::V1::LikesController < API::V1::BaseController
  def index
    @user = current_user # Added by Victor don't know if this is right
    @likes = Like.where(:user_id => @user.id).order("created_at DESC")
  end

  def create
    @chinchinId = params[:chinchin_id]

    chinchin = User.find(@chinchinId)

    begin
      if Like.find_by_user_id_and_chinchin_id(current_user.id, @chinchinId).nil?
        InteractionManager.like(:actor => current_user, :receiver => chinchin)
        render_api_message "created", :created
      else
        render_api_message "already liked", :ok
      end
    rescue
      render_api_message "api.v1.server_error", :internal_server_error
    end
  end
end
