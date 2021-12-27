# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def require_authentication
    return authenticate unless session_has_user_id?
    return if current_user&.id == session[:user]

    authenticate
  end

  def authenticate
    store_before_authentication_request_path
    redirect_to new_user_path
  end

  def store_before_authentication_request_path
    if request.get?
      session[:before_auth_request_path] = request.fullpath 
    else
      session[:before_auth_request_path] = nil
    end
  end

  def after_authentication_path
    before_auth_request_path = session.delete(:before_auth_request_path)
    before_auth_request_path || root_path
  end

  def current_user
    @current_user = User.find_by_id(session[:user]) if session_has_user_id?
  end

  def session_has_user_id?
    session[:user].present?
  end
end
