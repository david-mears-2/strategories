# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def authenticate
    return redirect_to new_user_path unless session_has_user_id?
    return if current_user&.id == session[:user]

    redirect_to new_user_path
  end

  def current_user
    @current_user = User.find_by_id(session[:user]) if session_has_user_id?
  end

  def session_has_user_id?
    session[:user].present?
  end
end
