class SignInForm < BaseForm
  validates :name, presence: true
  validates :user, presence: true, if: -> { name.present? }

  attr_accessor :name, :user

  def initialize(params = {})
    super(params)
    @user = User.find_by(name: params[:name])
  end
end
