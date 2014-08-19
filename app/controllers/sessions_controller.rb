class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      flash[:notice] = "Welcome back #{user.username}!"
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash[:error] = 'There was something wrong with your user name or password'
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

end