class List < ApplicationRecord
  belongs_to :round
  belongs_to :user

  has_many :entries
end
