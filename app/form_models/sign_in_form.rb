# frozen_string_literal: true

class SignInForm < BaseForm
  validates :name, presence: true
  validates :user, presence: true, if: -> { name.present? }

  attr_reader :name, :user

  def initialize(params = {})
    @name = params[:name]
    @user = User.find_by(name: params[:name])
    super
  end
end
