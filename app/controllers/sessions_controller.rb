class SessionsController < ApplicationController

  def new

  end

  def create

    user = User.find_by_username(params[:username])
    # If the user exists AND the password entered is correct.
    if user && user.authenticate(params[:password])
      # USER PASSED AUTHENTICATION
      # Save the user id inside the browser cookie. This is how we keep the user
      # logged in when they navigate around our website.
      session[:user_id] = user.id
      flash[:success] = t("login_welcome")
      redirect_to chat_path
    else
      flash[:danger] = t("wrong_login_data")
      redirect_to login_path
    end

  end

  def destroy
    session[:user_id] = nil
    flash[:success] = t("logout_ok")
    redirect_to root_path
  end

end
