# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :require_authentication, only: %i[edit update destroy]
  before_action :require_authorization, only: %i[edit update destroy]

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user] = @user.id
      redirect_to after_authentication_path, notice: "Welcome, friend."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_url(@user), notice: "Account successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    session.destroy

    redirect_to root_path, notice: "Account successfully destroyed."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name)
  end

  def require_authorization
    return if @user == current_user

    redirect_to user_path(@user), alert: "You aren't authorized to do that", status: :unprocessable_entity
  end
end
