class SessionController < ApplicationController
  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  def create
    user = User.find_by(username: params[:session][:username])
    if user && user.status == "ACTIVE"
      log_in(user)
    else
      flash.now[:danger] = 'Invalid email/password combination'
    end
    redirect_to main_path
  end
  def destroy
    log_out
    redirect_to home_path
  end
end
