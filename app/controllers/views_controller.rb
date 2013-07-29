class ViewsController < ApplicationController
  # Render mobile or desktop depending on User-Agent for these actions.
  before_filter :check_for_mobile, :only => [:index]
  before_filter :login_required

  def index
    @user = current_user
    avatar = Chinchin.find_by_uid(current_user.uid)
    @chinchins = avatar.viewers.map { |view| Chinchin.find_by_uid(view.viewer.uid) }

    respond_to do | format |
      format.html
      format.js {render :layout => false}
    end
  end

  def create
    viewee = Chinchin.find(params[:viewee_id].to_i)
    viewer = current_user
    if not viewee.nil? and not View.find_by_viewer_id_and_viewee_id(viewer.id, viewee.id)
      InteractionManager.view(viewer)
    end

    #   v = View.new
    #   v.viewer = viewer
    #   v.viewee = viewee
    #   if v.save and not viewee.user.nil?
    #     UrbanairshipWrapper.send([viewee.user], "Someone viewed your profile!")
    #   end

    render :nothing => true
  end
end