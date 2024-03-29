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

  def update
    message_room = MessageRoom.find(params[:id])
    action_type = params[:room_action]

    if action_type == "open"
      message_room.open(current_user)
    end

    #render :json => {status: false, message: "You don't have enough money to open this message room"}
    render :json => {status: true, message: "success"}
  end
end
