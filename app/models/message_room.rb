class MessageRoom < ActiveRecord::Base
  WAITING_FOR_OPEN = 0

  belongs_to :user1, :class_name => 'User'
  belongs_to :user2, :class_name => 'User'
end
