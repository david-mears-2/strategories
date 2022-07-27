class List < ApplicationRecord
  belongs_to :round
  belongs_to :user

  has_many :entries

  accepts_nested_attributes_for :entries

  validate :unique_to_round_and_user

  def unique_to_round_and_user
    return unless List.where(user: user, round: round)

    errors.add(:user, "Already submitted a list for this round")
  end
end
