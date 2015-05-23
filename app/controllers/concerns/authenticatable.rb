module Authenticatable
  extend ActiveSupport::Concern

  # Require Authenticated action.
  def authenticated!
    redirect_to new_sessions_path unless current_user
  end

  # Login
  # @param [User]   user  User
  # @param [String] token Credential token of User.
  def login(user, token)
    session[:uid] = user.uid
    session[:token] = token
  end

  # Get Login User.
  # @note When call this method, set @current_user variable.
  # @return [User] user.
  def current_user
    if session[:uid]
      @current_user ||= User.find_by(uid: session[:uid])
    else
      nil
    end
  end

  # Get Credential Token of Login user.
  # @return [String] token.
  def login_user_credential_token
    session[:token]
  end

  # Logout
  def logout
    session.delete(:uid)
    session.delete(:token)
  end
end
