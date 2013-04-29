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
  has_many :users, :through => :friendships
  has_many :likes
  has_many :profile_photos
  has_many :viewers, :class_name => 'View', :foreign_key => 'viewee_id'
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
    photos = self.photos
    photos.each do |photo|
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
    if photos.nil?
      photo_count = 0
    else
      photo_count = photos.size
    end
    self.photo_count = photo_count
    self.save
  end

  def mutual_friends(current_user)
    @mutual_friends ||= self.users & current_user.friends_in_chinchin.map { |c| c.user }
  end

  def self.update_photo_count
    Chinchin.all.each do |chinchin|
      begin
        photo_count = chinchin.photos.count
      rescue
        photo_count = 0
      end
      chinchin.photo_count = photo_count
      chinchin.save!
    end
  end
end
