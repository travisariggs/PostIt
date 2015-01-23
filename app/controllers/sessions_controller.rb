class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      # 1 or 2-stage authentication?
      if user.phone?
        setup_second_stage_auth(user)
        redirect_to pin_path
      else
        grant_access(user)
      end

    else
      flash[:error] = 'There was something wrong with your user name or password'
      redirect_to login_path
    end
  end

  def pin
    require_second_stage_auth_setup
    if request.post?
      user = User.find(session[:temp_id])
      if params[:pin] == user.pin
        complete_second_stage_auth(user)
        grant_access(user)
      else
        flash[:error] = "There was something wrong with your pin."
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def grant_access(user)
    flash[:notice] = "Welcome back #{user.username}!"
    session[:user_id] = user.id
    redirect_to root_path
  end

  def setup_second_stage_auth(user)
    # Set the user id in the session as temp_id until the second authentication
    session[:temp_id] = user.id
    user.generate_pin!
    # Send message to phone...
  end

  def complete_second_stage_auth(user)
    session[:temp_id] = nil
    user.remove_pin!
  end

  def require_second_stage_auth_setup
    access_denied('You cannot do that.') unless session[:temp_id] != nil
  end

end