class API::V1::InvitationsController < API::V1::BaseController
  def index
    type = params[:type]
    time_zone = params[:timeZoneName]

    @friends = Invitation.friends(@current_user, type: type, time_zone: time_zone)
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