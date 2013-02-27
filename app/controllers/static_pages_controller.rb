class StaticPagesController < ApplicationController
  def home
    if current_user
      redirect_to "/user/#{current_user.id}/chinchin"
    end
  end

# This controller is for a Facebook canvas app
  def fb4pp01
    # This code is added so the template does not use application.html.erb
    render :layout => false
  end

  def make_chinchin
    @user = User.find(params[:id])
    @user.delay.add_friends_to_chinchin

    render :text => 'making...'
  end

  def make_friendship
    users = User.all
    nil_count = 0
    new_count = 0
    users.each do |user|
      friends = user.friends
      friends.each do |friend|
        chinchin = Chinchin.find_by_uid(friend.identifier)
        if chinchin.nil?
          nil_count += 1
          chinchin = user.add_friend_to_chinchin(friend)
        end

        friendship = Friendship.find_by_user_id_and_chinchin_id(user.id, chinchin.id)
        if friendship.nil?
          new_count += 1
          friendship = Friendship.new
          friendship.user = user
          friendship.chinchin = chinchin
          friendship.save!
        end
      end
    end

    render :text => "nil_count: #{nil_count} - new_count #{new_count}"
  end
end
