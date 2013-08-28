class MessageRoom < ActiveRecord::Base
  WAITING_FOR_OPEN = 0
  OPENED_BY_USER1 = 1
  OPENED_BY_USER2 = 2
  CLOSED_BY_USER1 = 3
  CLOSED_BY_USER2 = 4

  belongs_to :user1, :class_name => 'User'
  belongs_to :user2, :class_name => 'User'
  has_many :messages

  attr_accessible :user1_id, :user2_id, :status

  scope :message_rooms, lambda { |pid|
    {
        :conditions => ['(user1_id = ? or user2_id = ?) and status <= 2', pid, pid],
        :order => 'updated_at DESC'
    }
  }

  def sendMessage(writer, text)
    if self.status != OPENED_BY_USER1 and self.status != OPENED_BY_USER2
      raise "The message room is not yet opened."
    end

    message = Message.new
    message.message_room = self
    message.writer = writer
    message.message_type = Message::TEXT
    message.content = text

    return message.save

    return true
  end

  def self.messageRoom(user1_id, user2_id)
    return MessageRoom.where("user1_id = ? and user2_id = ?", user1_id, user2_id).first || MessageRoom.where("user1_id = ? and user2_id = ?", user2_id, user1_id).first
  end

  def open(user)
    if user == self.user1
      self.status = OPENED_BY_USER1
    elsif user == self.user2
      self.status = OPENED_BY_USER2
    end
    self.save!
  end

  def close(user)
    if user == self.user1
      self.status = CLOSED_BY_USER1
    elsif user == self.user2
      self.status = CLOSED_BY_USER2
    end
    self.save!
  end
end
