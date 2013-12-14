class API::V1::ChinchinsController < API::V1::BaseController
  def index
    heart = @current_user.currency(Currency::HEART)
    heart.recalculate
    if not heart.is_available
      info = {:time_left => currency_timeleft(@current_user, Currency::HEART)}
      render_api_message "api.v1.no_more_heart", :too_many_requests, info
      return
    end

    @chinchin = @current_user.chinchin.first
    if @chinchin
      heart.use(1)
    else
      render_api_message "api.v1.no_more_matches", :not_found
      return
    end
  end
end