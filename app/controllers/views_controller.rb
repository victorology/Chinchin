class ViewsController < ApplicationController
  before_filter :check_for_mobile, :only => [:index]

  def index
    @views = current_user.viewers

    respond_to do | format |
      format.html
      format.js {render :layout => false}
    end
  end
end
