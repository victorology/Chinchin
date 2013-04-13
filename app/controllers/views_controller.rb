class ViewsController < ApplicationController
  # Render mobile or desktop depending on User-Agent for these actions.
  before_filter :check_for_mobile, :only => [:index]

  def index
    @views = current_user.viewers

    respond_to do | format |
      format.html
      format.js {render :layout => false}
    end
  end

  def create
    chinchin = Chinchin.find(params[:viewee_id].to_i)
    viewer = current_user
    viewee = User.find_by_uid(chinchin.uid)
    if not viewer.nil? and not viewee.nil?
      v = View.new
      v.viewer = viewer
      v.viewee = viewee
      v.save
    end

    render :nothing => true
  end
end
