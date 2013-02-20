class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :chinchin
  # attr_accessible :title, :body
end
