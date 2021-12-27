# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :participations
  has_many :games, through: :participations

  def points_from_all_games
    @points ||= participations.sum(:points)
  end
end
