class API::V1::MessageRoomsController < API::V1::BaseController
  def index
    @message_rooms = @current_user.message_rooms
  end
end