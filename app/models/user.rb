class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :participations
  has_many :games, through: :participations

  before_create { pick_color }
  COLOR_OPTIONS = %w[red blue green yellow pink purple white black gray orange].freeze

  def points_from_all_games
    @points_from_all_games ||= participations.sum(:points)
  end

  # return cumulative score for a given game
  def score(game)
    game.rounds.finished.includes(:lists).where("lists.user_id = #{id}").sum("lists.points")
  end

  def pick_color
    self.color = COLOR_OPTIONS[id]
  end
end
