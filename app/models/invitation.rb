class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :chinchin, :class_name => "User"

  def self.invited_friends(user)

    invitations = self.where('user_id = ? and created_at > ?', user.id, TimeUtil.get - 24.hours)
    invited_friends = invitations.map { |x| x.chinchin }.compact
  end
end
