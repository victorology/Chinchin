class MessagesController < ApplicationController
  before_filter :check_for_mobile, :only => [:index, :create]
  before_filter :login_required

  def index
    room = MessageRoom.find(params[:message_room_id])
    @user = current_user
    @receiver = nil
    if room.user1 == @user
      @receiver = room.user2
    elsif
      @receiver = room.user1
    end
    @messages = room.messages
  end

  def create
    message_room = MessageRoom.find(params[:message_room_id])
    message_text = params[:message]
    message = message_room.messages.build(writer: current_user, message_type:Message::TEXT, content:message_text)
    message.save!

    respond_to do | format |
      format.js {render :layout => false}
    end
  end
end
