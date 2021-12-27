# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :participations
  has_many :users, through: :participations
end
