class ApplicationController < ActionController::Base
  protect_from_forgery

  # Required for i18n
  before_filter :set_locale

  def check_for_mobile
    session[:mobile_override] = params[:mobile] if params[:mobile]
    prepare_for_mobile if mobile_device?
  end

  def prepare_for_mobile
    prepend_view_path Rails.root + 'app' + 'views_mobile'
  end

  def mobile_device?
    #session[:mobile_override] == "1"
    if session[:mobile_override]
       session[:mobile_override] == "1"
    else
       # Treats iPad as non-mobile.
       (request.user_agent =~ /Mobile|webOS/) && (request.user_agent !~ /iPad/)
    end
  end
  helper_method :mobile_device?

  # This is a method to fetch the current user via OmniAuth
  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
  end
  helper_method :current_user

  def logged_in?
    current_user
  end

  def admin_logged_in?
    admin_user_signed_in?
  end

  def login_required
    unless logged_in?
      redirect_to root_url
    end
  end

  def admin_login_required
    unless admin_logged_in?
      redirect_to "/admin"
    end
  end

  # Added for i18n
  def set_locale
    begin
      accept_language = request.env["HTTP_ACCEPT_LANGUAGE"].split(",")[0]
    rescue
      accept_language = 'ko_KR'
    end
    user_locale = current_user.locale if current_user

    I18n.locale = FindLocale.call(:user_locale => user_locale, :accept_language => accept_language)
  end
end
