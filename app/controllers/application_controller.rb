class ApplicationController < ActionController::Base
  protect_from_forgery

  # Required for i18n 
  before_filter :set_locale

  # This is a method to fetch the current user via OmniAuth
  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
  end
  helper_method :current_user

  # Added for i18n
  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
  end

end
