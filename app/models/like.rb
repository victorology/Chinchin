class Like < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :chinchin, :class_name => "User"

  def self.mutual_likes
    mutual_likes = []
    likes = Like.joins(:user).where("users.gender = 'female'")
    likes.each do |like|
      if Like.where('user_id = ? and chinchin_id = ?', like.chinchin.id, like.user.id).count > 0
        mutual_likes.push(like)
      end
    end

    return mutual_likes
  end
end
