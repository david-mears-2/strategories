class Game < ApplicationRecord
  has_many :participations
  has_many :users, through: :participations
  has_many :rounds
  belongs_to :host, class_name: "User"

  validates :code, uniqueness: true

  # This is the main intended interface for users
  # It returns users in a deterministic order
  def players
    users.order(:created_at)
  end

  enum status: %i[draft in_play finished]
end
