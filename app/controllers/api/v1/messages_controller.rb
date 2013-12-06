class API::V1::MessagesController < API::V1::BaseController
  def create
    messageRoom = MessageRoom.find(params[:room_id])
    content = params[:content]
    created_at = params[:created_at]

    message = Message.new
    message.message_room_id = messageRoom.id
    message.message_type = Message::TEXT
    message.writer = @current_user
    message.content = content
    message.created_at = DateTime.now
    #message.created_at = DateTime.strptime(created_at, "yyyy-MM-dd'T'HH:mm:ssZZZZ")

    begin
      if message.save
        render_api_message "created", :created, {:message_id => message.id}
      else
        render_api_message "api.v1.server_error", :internal_server_error
      end
    rescue
      render_api_message "api.v1.server_error", :internal_server_error
    end
  end
end
