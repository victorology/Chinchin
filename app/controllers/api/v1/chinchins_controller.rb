class API::V1::ChinchinsController < API::V1::BaseController
  def index
    @chinchin = @current_user.chinchin
  end
end