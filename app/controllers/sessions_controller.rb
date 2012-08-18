class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    # Changed from Railscast to redirect to old url as opposed to root_url
    redirect_to(:back)
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end