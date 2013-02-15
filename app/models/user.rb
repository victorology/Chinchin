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
  attr_accessible :birthday, :email, :employer, :first_name, :gender, :hometown, :last_name, :locale, :location, :name, :oauth_expires_at, :oauth_token, :position, :provider, :relationship_status, :school, :uid

  def self.from_omniauth(auth)
	  where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
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
	    user.oauth_expires_at = Time.at(auth.credentials.expires_at)
	    user.save!
	  end
	end

	def facebook
		@fb_user ||= FbGraph::User.me(oauth_token)
	end

	def friends
		@friends ||= facebook.friends
	end

  def friends_in_chinchin
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

  def chinchin
    chinchins = []
    self.friends_in_chinchin.each do |friend|
      chinchins.push(friend.friends)
    end

    chinchins.flatten!
    chinchins.shuffle!
    #chinchins.shuffle

    real_chinchins = []
    puts(chinchins.size)
    chinchins.each do |chinchin|
      #c = FbGraph::User.fetch(chinchin.raw_attributes["id"], :access_token => oauth_token)
      c = chinchin.fetch
      if c.raw_attributes["gender"] != self.gender
        real_chinchins.push(c)
      end

      if real_chinchins.size >= 3
        break
      end
    end

    return real_chinchins
  end

  def add_friends_to_chinchin
    friends = self.friends
    friends.each do |friend|
      c = Chinchin.find_by_uid(friend.raw_attributes['id'])
      if c.nil?
        fetched_c = friend.fetch
        ra = fetched_c.raw_attributes
        ra['location'] = ra['location']['name'] unless ra['location'].nil?
        ra['hometown'] = ra['hometown']['name'] unless ra['hometown'].nil?
        ra['employer'] = ra['employer'].first['name'] unless ra['employer'].nil?
        ra['position'] = ra['position'].first['name'] unless ra['position'].nil?
        ra['school'] = ra['school'].last['name'] unless ra['school'].nil?

        c = Chinchin.new(
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
            :locale => ra['locale']
        )
        c.save!

        if Friendship.find_by_user_id_and_chinchin_id(self.id, c.id).nil?
          friendship = Friendship.new
          friendship.user = self
          friendship.chinchin = c
          friendship.save!
        end
      end
    end
  end
end
