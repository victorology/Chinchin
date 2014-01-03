class API::V1::InvitationsController < API::V1::BaseController
  def index
    type = params[:type]

    fs = Friendship.where('user_id = ?', @current_user.id)
    @friends = fs.map {|x| x.chinchin}.compact
    @friends = @friends - @current_user.friends_in_chinchin
    if type.present? and type == 'available'
      invited_friends = Invitation.invited_friends(@current_user)
      @friends = @friends - invited_friends
    end
  end

  def create
    friendsString = params[:friends]
    via = params[:via]
    friendUIDs = friendsString.split(',')
    friends = friendUIDs.map { |uid| User.where('uid=?', uid).first }.compact
    if via.nil?
      via = "unknown"
    end
    Invitation.invite_friends(@current_user, friends, via)
  end
end