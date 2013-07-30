class Like < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :chinchin, :class_name => "User"
  # attr_accessible :title, :body
end
