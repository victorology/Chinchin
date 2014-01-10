class User < ActiveRecord::Base
  UNREGISTERED = 0
  REGISTERED = 1
  FRIENDS_FETCHED = 2
  NO_FOUND_FRIENDS = 3
  FOUND_FRIENDS = 4
  NO_FOUND_CHINCHINS = 5
  FOUND_CHINCHINS = 6

  attr_accessible :birthday, :email, :employer, :first_name, :gender, :hometown, :last_name, :locale, :location, :name, :oauth_expires_at, :oauth_token, :position, :provider, :relationship_status, :school, :uid
  has_many :friendships
  has_many :chinchins, :through => :friendships
  has_many :likes
  has_many :viewees, :class_name => 'View', :foreign_key => 'viewer_id'
  has_many :viewers, :class_name => 'View', :foreign_key => 'viewee_id'
  has_many :profile_photos, :foreign_key => 'chinchin_id'
  has_many :currencies

  serialize :sorted_chinchin
  serialize :chosen_chinchin

  def update_from_omniauth(auth)
    self.provider = auth.provider
    self.uid = auth.uid
    self.name = auth.info.name
    self.email = auth.info.email
    self.bio = auth.info.bio
    self.quotes = auth.info.quotes
    self.username = auth.info.username
    self.first_name = auth.info.first_name
    self.last_name = auth.info.last_name
    self.birthday = auth.extra.raw_info.birthday
    self.location = auth.extra.raw_info.location.name unless auth.extra.raw_info.location.nil?
    self.hometown = auth.extra.raw_info.hometown.name unless auth.extra.raw_info.hometown.nil?
    # Takes the most recent employer and position.
    unless auth.extra.raw_info.work.nil?
      unless auth.extra.raw_info.work.first.employer.nil?
        self.employer = auth.extra.raw_info.work.first.employer.name
      end
      unless auth.extra.raw_info.work.first.position.nil?
        self.position = auth.extra.raw_info.work.first.position.name
      end
    end
    self.gender = auth.extra.raw_info.gender
    self.relationship_status = auth.extra.raw_info.relationship_status
    # Takes the most recent entry but should take College if it exists.
    unless auth.extra.raw_info.education.nil?
      self.school = auth.extra.raw_info.education.first.school.name
    end
    self.locale = auth.extra.raw_info.locale
    self.oauth_token = auth.credentials.token
    self.oauth_expires_at = Time.at(auth.credentials.expires_at) unless auth.credentials.expires_at.nil?
    if self.status != REGISTERED
      self.status = REGISTERED
      self.registered_at = TimeUtil.get
    end
    self.save!
    self.delay.add_friends_to_chinchin
    self.delay.fetch_profile_photos
  end

  def self.create_from_omniauth(auth)
	  user = User.new
    #user.update_from_omniauth(auth)
    return user
	end

  def renew_credential
    auth = FbGraph::Auth.new('352455024800701', '035385fe9e7db60eba187ab83fb27cb6')
    auth.exchange_token! self.oauth_token
    if auth.access_token.access_token != self.oauth_token
      self.oauth_token = auth.access_token.access_token
      self.oauth_expires_at = Time.now + auth.access_token.expires_in
      self.save
    end
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
    self.chinchins.where('users.status > 0')
  end

  def friends_in_chinchin
    registered_friends
  end

  def people_in_leaderboard
    chinchins = self.chinchins
    leaders = []

    chinchins.each do |chinchin|
      leader = Hash.new(0)
      leader[:chinchin] = chinchin
      leader[:likes] = Like.where("chinchin_id = ?", chinchin.id).count
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

  def generate_sorted_chinchin
    chinchin_in_chinchin = []
    chinchin_not_in_chinchin = []
    self.friends_in_chinchin.each do |friend|
      chinchin_in_chinchin.push(friend.friends_in_chinchin.collect{|x| x.id})
      chinchin_not_in_chinchin.push(friend.chinchins.collect{|x| x.id})
    end

    chinchin_in_chinchin.flatten!
    chinchin_in_chinchin.shuffle!

    chinchin_not_in_chinchin.flatten!
    chinchin_not_in_chinchin.shuffle!

    sorted_chinchin = (chinchin_in_chinchin + chinchin_not_in_chinchin).uniq
    if self.chosen_chinchin.present?
      sorted_chinchin = sorted_chinchin - self.chosen_chinchin
    end

    if sorted_chinchin.count > 0
      self.sorted_chinchin = sorted_chinchin
      self.status = FOUND_CHINCHINS
    else
      self.status = NO_FOUND_CHINCHINS
    end
    self.save

    return sorted_chinchin
  end

  def chinchin
    chinchins = self.sorted_chinchin
    if chinchins.nil? or chinchins.count == 0
      return []
    end

    while chinchins.count > 0
      chinchin_id = chinchins.shift
      self.sorted_chinchin = chinchins
      if self.chosen_chinchin.nil?
        self.chosen_chinchin = [chinchin_id]
      else
        self.chosen_chinchin << chinchin_id
      end
      self.save

      chinchin = User.find(chinchin_id)
      if pass_default_chinchin_filter(chinchin)
        return [chinchin]
      end
    end

    return []
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
        :provider => 'facebook',
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
    #u.delay.fetch_profile_photos
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

      if Friendship.find_by_user_id_and_chinchin_id(u.id, self.id).nil?
        friendship = Friendship.new
        friendship.user = u
        friendship.chinchin = self
        friendship.save!
      end

      if u.status == User::NO_FOUND_CHINCHINS
        u.jump to: User::FOUND_CHINCHINS
      end

      if u.status > 0
        Notification.notify(type: "friend_join", media: ['push'], people: [self], receivers: [u])
        u.generate_sorted_chinchin
      end
    end
    self.generate_sorted_chinchin
  end

  def jump(options)
    from = self.status
    to = options[:to]
    self.status = to
    if self.save
      Jump.create(user: self, from: from, to: to)
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
    # return false if chinchin.user.nil?
    # me = Chinchin.find_by_uid(self.uid)
    self.liked(chinchin) and chinchin.liked(self)
  end

  def mutual_friends(user)
    # @mutual_friends ||= self.users & current_user.friends_in_chinchin
    mutual_friendships(user)
  end

  def mutual_friendships(user)
    @mutual_friendships ||= user.friends_in_chinchin & self.friends_in_chinchin
  end


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

  #def connect_with_chinchin
  #  c = Chinchin.find_by_uid(self.uid)
  #  if not c.nil?
  #    c.user = self
  #    c.save
  #  end
  #end

  def message_rooms
    MessageRoom.message_rooms(self.id)
  end

  def photos
    friend = self.friends_in_chinchin.last || self
    fb_user = FbGraph::User.new(self.uid, :access_token => friend.oauth_token)
    albums = fb_user.albums
    albums.each do |album|
      if album.name == 'Profile Pictures' and album.photos.count > 0
        return album.photos
      end
    end

    return []
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

  def currency(currency_type=Currency::HEART)
    c = Currency.where('user_id = ? and currency_type = ?', self.id, currency_type).last
    if c.nil?
      c = Currency.init(self, currency_type)
    end

    return c
  end

  def use_currency(currency_type)
    c = self.currency(currency_type)
    if c.current_count > 0
      c.use(1)
    end
  end

  def build_token
    begin
      token = SecureRandom.urlsafe_base64
    end while User.exists?(auth_token: token)
    token
  end

  def age
    begin
      birthday = Date.strptime(self.birthday, '%m/%d/%Y')
      now = Time.now.utc.to_date
      now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
    rescue TypeError, ArgumentError
      nil
    end
  end

  def horoscope
    begin
      birthday = Date.strptime(self.birthday, '%m/%d/%Y')
      birthday.zodiac_sign
    rescue TypeError, ArgumentError
      nil
    end
  end

  def invite(not_yet_user, via="unknown")
    invitation = Invitation.new
    invitation.user = self
    invitation.chinchin = not_yet_user
    invitation.via = via
    invitation.save

    if self.email.present? and not_yet_user.username.present?
      self.send_invitation_mail(not_yet_user)
    end
  end

  def send_invitation_mail(not_yet_user)
    require 'mandrill'
    mandrill = Mandrill::API.new("56WqO0Ss9B6YSsEaY_cUVw", true)
    email = not_yet_user.username + "@facebook.com"
    mandrill.messages.send_template('invitation-for-school-dating-app',
                                    [
                                    ],
                                    {
                                        :subject => "Invitation for AU dating app",
                                        :from_email => self.email,
                                        :from_name => self.name,
                                        :tags => [
                                            "fb-onboarding"
                                        ],
                                        :to => [
                                            {
                                                :email => email,
                                                :type => "to"
                                            }
                                        ],
                                        :merge_vars => [
                                            :rcpt => email,
                                            :vars => [
                                                {
                                                    :name => 'school',
                                                    :content => school
                                                },
                                                {
                                                    :name => 'fname',
                                                    :content => not_yet_user.first_name
                                                },
                                                {
                                                    :name => 'fname',
                                                    :content => not_yet_user.first_name
                                                }
                                            ]
                                        ]
                                    }
    )
  end

  def abc
    users = User.where('status = 1')
    users = users - self.friends_in_chinchin
    fs1 = Friendship.where('user_id = ?', self.id)
    abcs = []
    users.each do |u|
      if self.uid == u.uid
        next
      end

      fs2 = Friendship.where('user_id = ?', u.id)
      if (fs1 & fs2).count > 0
        abc = {user: self, chinchin: u, friendship: fs1&fs2}
        abcs.push(abc)
      end
    end
  end
end
