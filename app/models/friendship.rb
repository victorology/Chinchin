class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :chinchin, :class_name => "User"
end
