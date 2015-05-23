class ApplicationController < ActionController::Base
  include Authenticatable

  protect_from_forgery with: :exception

  before_action :set_current_user

  def set_current_user
    @current_user = current_user
  end
end
