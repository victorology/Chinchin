class Like < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :chinchin
  # attr_accessible :title, :body
end
