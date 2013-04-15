class ProfilePhoto < ActiveRecord::Base
  belongs_to :chinchin, touch: true
  attr_accessible :chinchin_id, :facebook_likes, :picture_url, :source_url
end
