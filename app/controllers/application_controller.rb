class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception

  helper_method :logged_in?

  def logged_in?
    StupidlySimpleAuthentication.authenticated?(cookies.signed[:token])
  end

  private ######################################################################

  def require_login
    redirect_to new_session_path unless logged_in?
  end

  def require_no_login
    redirect_to root_path if logged_in?
  end

  def no_sidebar
    @no_sidebar = true
  end
end
