class MessageRoomsController < ApplicationController
  before_filter :check_for_mobile, :only => [:index, :show]
  before_filter :login_required

  def index
    @user = current_user

    respond_to do | format |
      format.js {render :layout => false}
      format.html
    end
  end

  def show
    @message_room = MessageRoom.find(params[:id])

    respond_to do | format |
      format.js {render :layout => false}
      format.html
    end
  end
end
