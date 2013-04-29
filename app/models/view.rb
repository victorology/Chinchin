class View < ActiveRecord::Base
  belongs_to :viewer, :class_name => "User"
  belongs_to :viewee, :class_name => "Chinchin"
  # attr_accessible :title, :body
end
