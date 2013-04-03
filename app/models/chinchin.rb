#
# Table name: chinchins
#
#  id                  :integer          not null, primary key
#  provider            :string(255)
#  uid                 :string(255)
#  name                :string(255)
#  email               :string(255)
#  first_name          :string(255)
#  last_name           :string(255)
#  birthday            :string(255)
#  location            :string(255)
#  hometown            :string(255)
#  employer            :string(255)
#  position            :string(255)
#  gender              :string(255)
#  relationship_status :string(255)
#  school              :string(255)
#  locale              :string(255)
#  oauth_token         :string(255)
#  oauth_expires_at    :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Chinchin < ActiveRecord::Base
  belongs_to :user
  has_many :friendships
  has_many :likes
  has_many :profile_photos
  attr_accessible :birthday, :email, :employer, :first_name, :gender, :hometown, :last_name, :locale, :location, :name, :oauth_expires_at, :oauth_token, :position, :provider, :relationship_status, :school, :uid
  # attr_accessible :title, :body

  def endpoint
    ['https://graph.facebook.com', "#{self.uid}"].join('/')
  end

  def picture(options_or_size = {})
    options = if options_or_size.is_a?(String) || options_or_size.is_a?(Symbol)
                {:type => options_or_size}
              else
                options_or_size
              end
    _endpoint_ = ["#{self.endpoint}/picture", options.to_query].delete_if(&:blank?).join('?')
  end

def photos
  friend = self.friendships.first.user
  fb_user = FbGraph::User.new(self.uid, :access_token => friend.oauth_token)
  albums = fb_user.albums
  albums.each do |album|
    if album.name == 'Profile Pictures' and album.photos.count > 0
      return album.photos
    end
  end

  return nil
end

  def facebook_likes
    friend = self.friendships.first.user
    fb_user = FbGraph::User.new(self.uid, :access_token => friend.oauth_token)
    fb_user.likes
  end

  def score
    self.likes.count * 10
  end

  def fetch_profile_photos
    self.photos.each do |photo|
      if ProfilePhoto.find_by_picture_url(photo.source).nil?
        pp = ProfilePhoto.new
        pp.picture_url = photo.source
        pp.source_url = photo.images.first.source
        pp.created_at = photo.created_time
        pp.facebook_likes = photo.likes.count
        pp.chinchin = self
        pp.save
      end
    end
  end
end
