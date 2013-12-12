class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :chinchin, :class_name => "User"

  def self.invited_friends(user)
    invitations = self.where('user_id = ? and created_at > ?', user.id, TimeUtil.get - 24.hours)
    invited_friends = invitations.map { |x| x.chinchin }.compact
  end

  def self.invite_friends(user, friends, via)
    friends.each do |friend|
      user.invite(friend, via)
    end

    if friends.count >= 20
      c = user.currency(Currency::HEART)
      c.recharge_full('invitation')
    end
  end
end
