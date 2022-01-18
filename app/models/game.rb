class Game < ApplicationRecord
  has_many :participations
  has_many :users, through: :participations
  has_many :rounds

  enum status: %i[draft in_play finished]
end
