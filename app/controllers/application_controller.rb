class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :admin?, :access_denied

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      nil
    end
  end

  def logged_in?
    !!current_user
  end

  def require_user
    access_denied('You have to be logged in to do that!') unless logged_in?
  end

  def require_admin
    access_denied unless logged_in? and current_user.admin?
  end

  def access_denied(message='Only the boss can do that...', redirect=root_path)
    flash[:error] = message
    redirect_to redirect
  end

end
