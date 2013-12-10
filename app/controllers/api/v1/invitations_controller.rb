class API::V1::InvitationsController < API::V1::BaseController
  def index
    type = params[:type]

    fs = Friendship.where('user_id = ?', @current_user.id)
    @friends = fs.map {|x| x.chinchin}.compact
    if type.present? and type == 'available'
      invited_friends = Invitation.invited_friends(@current_user)
      @friends = @friends - invited_friends
    end
  end

  def create

  end
end