class ApplicationController < ActionController::Base

  helperMethods = [
    :current_user,
    :authorize,
    :isLogged?
  ]

  helper_method helperMethods

  #Handle with user accounts & sessions
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # keeps lock pages to logged in users
  def authorize
    redirect_to login_path unless current_user
  end

  # boolean answer to is logged?
  def isLogged?
    if current_user
      true
    else
      false
    end
  end

end
