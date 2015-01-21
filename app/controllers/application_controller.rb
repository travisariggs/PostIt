class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :admin?

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

  def admin?
    if logged_in?
      current_user.role == 'admin'
    else
      false
    end
  end

  def require_user
    if not logged_in?
      flash[:error] = 'You have to be logged in to do that!'
      redirect_to root_path
    end
  end

  def require_admin
    if not admin?
      flash[:error] = 'Only the boss can do that...'
      redirect_to root_path
    end
  end

end
