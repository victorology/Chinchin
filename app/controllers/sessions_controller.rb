class SessionsController < ApplicationController
  def create
  	auth = env["omniauth.auth"]
    user = User.where(auth.slice(:provider, :uid)).first
    next_url = root_url

    if user.status == User::UNREGISTERED
      user.update_from_omniauth(auth)
    end

    unless user
    	user = User.create_from_omniauth(auth)
    	next_url = tutorials_url
    end
    user.last_login = Time.now
    session[:user_id] = user.id
    redirect_to next_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end