class API::V1::MessageRoomsController < API::V1::BaseController
  def index
    @message_rooms = @current_user.message_rooms
  end

  def show
    message_room_id = params[:id]
    if message_room_id.nil?
      render_api_message "api.v1.bad_request", :bad_request
    end

    @message_room = MessageRoom.find(message_room_id)
    if @message_room.nil?
      render_api_message "api.v1.not_found", :not_found
    end
    @messages = Message.where('message_room_id = ?', message_room_id)
  end
end