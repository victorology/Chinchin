class API::V1::UsersController < API::V1::BaseController
  def show

    @user = @current_user
    if params[:id] != 'me'
      @user = User.find(params[:id])
    end

    if @user.nil?
      render_api_message "api.v1.bad_request", :bad_request
    end
  end

  def update
    device_token = params[:device_token]
    if device_token.nil?
      render_api_message "api.v1.bad_request", :bad_request
    end

    @current_user.device_token = device_token
    @current_user.save
  end
end