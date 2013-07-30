class View < ActiveRecord::Base
  belongs_to :viewer, :class_name => "User"
  belongs_to :viewee, :class_name => "User"
  # attr_accessible :title, :body
end
