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

  def check_for_mobile
    session[:mobile_override] = params[:mobile] if params[:mobile]
    prepare_for_mobile if mobile_device?
  end

  def prepare_for_mobile
    prepend_view_path Rails.root + 'app' + 'views_mobile'
  end

  def mobile_device?
    if session[:mobile_override]
      session[:mobile_override] == "1"
    else
      # This treats iPad as non-mobile
      (request.user_agent =~ /mobile|webOS/) && (request.user_agent !~ /iPad/)
    end
  end
  helper_method :mobile_device?

end
