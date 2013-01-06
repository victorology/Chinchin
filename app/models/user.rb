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

	def age
		birthday = Date.strptime(self.birthday, '%m/%d/%Y')
		now = Time.now.utc.to_date
		now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
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
end
