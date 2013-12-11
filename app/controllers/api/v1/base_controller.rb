class API::V1::BaseController < ActionController::Base
  before_filter :token_authenticate
  respond_to :json

  private

  def token_authenticate
    unless params["auth_token"].present? and params["auth_signature"].present?
      api_not_authenticated
      return
    end
    user = User.find_by_auth_token(params["auth_token"])
    if user.nil?
      api_not_authenticated
    else
      hash = OpenSSL::HMAC.digest('sha256', user.auth_secret, user.uid)
      valid_signature = Base64.encode64(hash).chomp
      unless params["auth_signature"] == valid_signature
        api_not_authenticated
        return
      end
      @current_user = user
    end
  end

  def api_not_authenticated
    render_api_message "api.v1.unauthorized", :unauthorized
  end

  def render_api_message(message, status, info={})
    if status == :too_many_requests
      status = 429
    end
    render :json => {:message => message, :status => status, :info => info}, :status => status
  end

  def currency_timeleft(user, currency_type)
    c = user.currency(currency_type)
    if c.last_used_log.nil?
      return 0
    end
    return ((30*60) - (TimeUtil.get - c.last_used_log.created_at)) * 1000
  end
end