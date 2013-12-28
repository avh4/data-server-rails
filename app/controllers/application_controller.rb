class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  force_ssl unless Rails.env.development?

  before_action :authenticate

  protected

  def user_id
    @user_id
  end

  def authenticate
    @user_id = request.headers['HTTP_X_USER_ID']
    if @user_id.blank?
      head :unauthorized
      return false
    else
      return true
    end
  end
end
