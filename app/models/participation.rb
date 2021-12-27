# frozen_string_literal: true

class Participation < ApplicationRecord
  belongs_to :game
  belongs_to :user
end
