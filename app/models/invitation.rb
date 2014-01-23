class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :chinchin, :class_name => "User"

  def self.friends(user, options)
    type = options[:type]
    time_zone = options[:time_zone]
    if type.present? and type == 'available'
      fs = Friendship.where('user_id = ?', user.id)
      friends = fs.map {|x| x.chinchin}.compact
      friends = friends - user.friends_in_chinchin
      invited_friends = Invitation.invited_friends(user)
      friends = friends - invited_friends
    else
      friends = Invitation.invited_friends(user, time_zone)
    end

    friends
  end

  def self.invited_friends(user, time_zone='US/Pacific')
    zone_noon = TimeUtil.get_last_noon(time_zone)
    invitations = self.where('user_id = ? and created_at > ?', user.id, zone_noon)
    invited_friends = invitations.map { |x| x.chinchin }.compact
  end

  def self.invite_friends(user, friends, via)
    friends.each do |friend|
      user.invite(friend, via)
    end

    if via == 'no_hearts' and friends.count >= 5
      c = user.currency(Currency::HEART)
      c.recharge_full('invitation')
    end

    if via == 'onboarding' and user.status == User::NO_FOUND_CHINCHINS_ONBOARDING
      user.status = User::NO_FOUND_CHINCHINS
      user.save
    end
  end

  def phone_number
    contact = Contact.where('name=?', self.chinchin.name).first
    if contact
      return contact.phone_number
    end
  end

  after_create {
    self.created_at = TimeUtil.get
    self.save
  }
end
