class API::V1::ChinchinsController < API::V1::BaseController
  def index
    heart = @current_user.currency(Currency::HEART)
    heart.recalculate
    if not heart.is_available
      render_api_message "api.v1.no_more_heart", :too_many_requests
      return
    end

    heart.use(1)
    @chinchin = @current_user.chinchin.first
  end
end