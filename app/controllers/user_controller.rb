class UserController < ApplicationController
  # skip_before_action :verify_authenticity_token

  def create
    @user = User.new(params.require(:user).permit(:username))
    does_user_exist = User.find_by_sql("SELECT 1 AS result FROM users WHERE username = '#{params[:user][:username]}' LIMIT 1")

    if does_user_exist.count == 0 && @user.save
      session[:user_id] = @user.id
      redirect_to main_path
    else
      redirect_to home_path
    end
  end
end
