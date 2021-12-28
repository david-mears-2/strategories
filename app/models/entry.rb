# frozen_string_literal: true

class Entry < ApplicationRecord
  belongs_to :list
  has_many :votes
end
