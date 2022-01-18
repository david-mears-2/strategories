class Round < ApplicationRecord
  belongs_to :game
  has_one :rule
  has_many :lists

  enum status: %i[draft in_play finished]
end
