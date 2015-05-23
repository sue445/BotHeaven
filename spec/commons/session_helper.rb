module SessionHelper
  # Login
  # @param [User]   user  User
  # @param [String] token Credential token of User.
  def login(user, token='dummy')
    session[:uid] = user.uid
    session[:token] = token
  end
end
