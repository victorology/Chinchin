class Message < ActiveRecord::Base
	after_save :send_push
  attr_accessible :message_type, :content, :writer, :message_room

  TEXT = 0

  belongs_to :message_room, touch: true
  belongs_to :writer, :class_name => 'User'

  private
	  def send_push
	  	receiver = self.message_room.user1 
	  	receiver = self.message_room.user2 if writer == message_room.user1
	  	UrbanairshipWrapper.send([receiver], self.content)
	  end
end