class SessionsController < ApplicationController
  before_filter :check_for_mobile

  def create
  	auth = env["omniauth.auth"]
    user = User.where(auth.slice(:provider, :uid)).first
    next_url = root_url
    status = :ok

    unless user
    	user = User.create_from_omniauth(auth)
    	next_url = tutorials_url
      status = :created
    end

    if user.status == User::UNREGISTERED
      next_url = tutorials_url
      status = :created
    end
    # important fix to update already registered user's auth token
    user.update_from_omniauth(auth)

    user.last_login = Time.now
    session[:user_id] = user.id

    if params[:provider] == 'facebook_access_token'
      message = {:status => status, :message=>'ok'}
      begin
        user.renew_credential
        auth_token = user.build_token
        user.auth_token = auth_token
        user.auth_secret = SecureRandom.urlsafe_base64
        user.save
        message[:user_id] = user.id
        message[:auth_token] = user.auth_token
        message[:auth_secret] = user.auth_secret
      rescue => e
        message[:message] = e.message
        message[:status] = :internal_server_error
      end
      render json: message
    else
      redirect_to next_url
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

  def failure
    if params[:message] == 'facebook_access_token'
      message = {'message'=>params[:message]}
      render json: message
    else
      redirect_to root_url
    end
  end
end