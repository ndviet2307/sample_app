class ApplicationController < ActionController::Base
  include SessionsHelper
  protect_from_forgery with: :exception

  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  private

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "user.alert.error.login"
    redirect_to login_url
  end
end
