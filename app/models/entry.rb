class Entry < ApplicationRecord
  belongs_to :list
  has_many :votes
end
