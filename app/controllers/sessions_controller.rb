# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    @sign_in_form = SignInForm.new
  end

  def create
    @sign_in_form = SignInForm.new(sign_in_form_params)
    @user = @sign_in_form.user
    if @sign_in_form.valid?
      session[:user] = @user.id
      redirect_to root_path, notice: "Welcome, friend."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.destroy
    redirect_to root_path
  end

  private

  def sign_in_form_params
    params.require(:sign_in_form).permit(:name)
  end
end
