class List < ApplicationRecord
  belongs_to :round
  belongs_to :player, class_name: "User", foreign_key: "user_id"

  has_many :entries

  accepts_nested_attributes_for :entries

  validate :unique_to_round_and_player, on: :create

  def unique_to_round_and_player
    return unless List.where(player:, round:).any?

    errors.add(:player, "Already submitted a list for this round")
  end
end
