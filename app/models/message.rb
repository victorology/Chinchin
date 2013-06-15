class Message < ActiveRecord::Base
  attr_accessible :message_type, :content, :writer, :message_room

  TEXT = 0

  belongs_to :message_room
  belongs_to :writer, :class_name => 'User'
end
