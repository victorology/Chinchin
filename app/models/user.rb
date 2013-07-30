# == Schema Information
#
# Table name: users
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

class User < ActiveRecord::Base
  UNREGISTERED = 0
  REGISTERED = 1

  attr_accessible :birthday, :email, :employer, :first_name, :gender, :hometown, :last_name, :locale, :location, :name, :oauth_expires_at, :oauth_token, :position, :provider, :relationship_status, :school, :uid
  has_many :friendships
  has_many :chinchins, :through => :friendships
  has_many :likes
  has_many :viewees, :class_name => 'View', :foreign_key => 'viewer_id'

  def self.create_from_omniauth(auth)
	  user = User.new
    user.provider = auth.provider
    user.uid = auth.uid
    user.name = auth.info.name
    user.email = auth.info.email
    user.first_name = auth.info.first_name
    user.last_name = auth.info.last_name
    user.birthday = auth.extra.raw_info.birthday
    user.location = auth.extra.raw_info.location.name unless auth.extra.raw_info.location.nil?
    user.hometown = auth.extra.raw_info.hometown.name unless auth.extra.raw_info.hometown.nil?
    # Takes the most recent employer and position.
    unless auth.extra.raw_info.work.nil?
	    unless auth.extra.raw_info.work.first.employer.nil?
	    	user.employer = auth.extra.raw_info.work.first.employer.name
	    end
	    unless auth.extra.raw_info.work.first.position.nil?
	    	user.position = auth.extra.raw_info.work.first.position.name
	    end
  	end
    user.gender = auth.extra.raw_info.gender
    user.relationship_status = auth.extra.raw_info.relationship_status
    # Takes the most recent entry but should take College if it exists.
    unless auth.extra.raw_info.education.nil?
    	user.school = auth.extra.raw_info.education.first.school.name
    end
    user.locale = auth.extra.raw_info.locale
    user.oauth_token = auth.credentials.token
    user.oauth_expires_at = Time.at(auth.credentials.expires_at) unless auth.credentials.expires_at.nil?
    user.status = REGISTERED
    user.save!
    user.delay.add_friends_to_chinchin
    user.delay.connect_with_chinchin

    return user
	end

	def facebook
		@fb_user ||= FbGraph::User.me(oauth_token)
	end

	def friends
    begin
		  @friends ||= facebook.friends
    rescue
      []
    end
	end

  def registered_friends
    self.chinchins.where('users.status = 1')
  end

  def friends_in_chinchin
    registered_friends
  end

  def friends_in_chinchin2
    users = User.all
    friends = self.friends
    chinchin = []

    friends.each do |friend|
      users.each do |user|
        if friend.raw_attributes["id"] == user.uid
          chinchin.push(user)
        end
      end
    end

    return chinchin
  end

  def chinchins_in_leaderboard
    friendships = Friendship.find_all_by_user_id(self.id)
    leaders = []

    friendships.each do |friendship|
      c = friendship.chinchin
      leaders.push({:chinchin => c, :score => c.score})
    end

    leaders.sort_by { |leader| leader[:score] }

    return leaders.slice 0, 10
  end

  def people_in_leaderboard
    chinchins = self.chinchins
    leaders = []

    chinchins.each do |chinchin|
      leader = Hash.new(0)
      leader[:chinchin] = chinchin
      leader[:likes] = chinchin.likes.count #Like.where("likes.chinchin_id == ", chinchin.id).count
      leader[:viewed] = chinchin.viewers.count
      leader[:total_score] = leader[:likes] * 10 + leader[:viewed]

      if leader[:total_score] > 0
        leaders.push(leader)
      end
    end

    leaders.sort_by! { |leader| leader[:total_score] }.reverse!

    return leaders
  end

  def pass_default_chinchin_filter(chinchin)
    status = (not chinchin.gender.nil?) && chinchin.gender != self.gender
    status = status && (chinchin.relationship_status != 'Married' and chinchin.relationship_status != 'Engaged')
    return status
  end

  def chinchin
    friendships = []
    self.friends_in_chinchin.each do |chinchin|
      friend = chinchin.user
      friendships.push(Friendship.find_all_by_user_id(friend.id))
    end

    friendships.flatten!
    friendships.shuffle!

    chinchins = []
    friendships.each do |friendship|
      chinchin = friendship.chinchin
      if pass_default_chinchin_filter(chinchin)
        chinchins.push(chinchin)
      end

      if chinchins.size >= 1
        break
      end
    end

    return chinchins
  end

  def add_friend_to_chinchin(friend)
    fetched_c = friend.fetch
    ra = fetched_c.raw_attributes
    ra['location'] = ra['location']['name'] unless ra['location'].nil?
    ra['hometown'] = ra['hometown']['name'] unless ra['hometown'].nil?
    ra['employer'] = ra['employer'].first['name'] unless ra['employer'].nil?
    ra['position'] = ra['position'].first['name'] unless ra['position'].nil?
    ra['school'] = ra['school'].last['name'] unless ra['school'].nil?

    u = User.new(
        :uid => ra['id'],
        :name => ra['name'],
        :email => ra['email'],
        :first_name => ra['first_name'],
        :last_name => ra['last_name'],
        :birthday => ra['birthday'],
        :location => ra['location'],
        :hometown => ra['hometown'],
        :employer => ra['employer'],
        :position => ra['position'],
        :gender => ra['gender'],
        :relationship_status => ra['relationship_status'],
        :school => ra['school'],
        :locale => ra['locale'],
    )
    u.status = UNREGISTERED
    u.save!
    u.delay.fetch_profile_photos
    u
  end

  def add_friends_to_chinchin
    friends = self.friends
    friends.each do |friend|
      u = User.find_by_uid(friend.raw_attributes['id'])
      if u.nil?
        u = self.add_friend_to_chinchin(friend)
      end

      if Friendship.find_by_user_id_and_chinchin_id(self.id, u.id).nil?
        friendship = Friendship.new
        friendship.user = self
        friendship.chinchin = u
        friendship.save!
      end
    end
  end

  def add_friends_to_chinchin2
    friends = self.friends
    friends.each do |friend|
      c = Chinchin.find_by_uid(friend.raw_attributes['id'])
      if c.nil?
        c = self.add_friend_to_chinchin(friend)
      end

      if Friendship.find_by_user_id_and_chinchin_id(self.id, c.id).nil?
        friendship = Friendship.new
        friendship.user = self
        friendship.chinchin = c
        friendship.save!
      end
    end
  end

  def like(chinchin)
    like = Like.new
    like.user = self
    like.chinchin_id = chinchin.id
    like.save
  end

  def liked(chinchin)
    if chinchin.nil?
      return false
    end

    like = Like.find_by_user_id_and_chinchin_id(self.id, chinchin.id)
    if like.nil?
      false
    else
      true
    end
  end

  def view(chinchin)
    v = View.new
    v.viewer = self
    v.viewee_id = chinchin.id
    v.save
  end

  def viewed(chinchin)
    return nil if chinchin.nil?
    View.where(viewer_id: self.id, viewee_id: chinchin.id).present?    
  end

  def mutual_like(chinchin)
    return false if chinchin.user.nil?
    me = Chinchin.find_by_uid(self.uid)
    self.liked(chinchin) and chinchin.user.liked(me)
  end

  # def mutual_friends(current_user)
  #   @mutual_friends ||= self.users & current_user.friends_in_chinchin
  # end

  def make_friendship
    friends = self.friends
    friends.each do |friend|
      chinchin = Chinchin.find_by_uid(friend.identifier)
      if chinchin.nil?
        chinchin = self.add_friend_to_chinchin(friend)
      end

      friendship = Friendship.find_by_user_id_and_chinchin_id(self.id, chinchin.id)
      if friendship.nil?
        friendship = Friendship.new
        friendship.user = self
        friendship.chinchin = chinchin
        friendship.save!
      end
    end
  end

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

  def mutual_friendships(user)
    @mutual_friendships ||= user.friends_in_chinchin & self.friends_in_chinchin
  end

  def connect_with_chinchin
    c = Chinchin.find_by_uid(self.uid)
    if not c.nil?
      c.user = self
      c.save
    end
  end

  def message_rooms
    MessageRoom.message_rooms(self.id)
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
end
