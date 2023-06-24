class List < ApplicationRecord
  belongs_to :round
  belongs_to :player, class_name: "User", foreign_key: "user_id"

  has_many :entries

  accepts_nested_attributes_for :entries

  validate :unique_to_round_and_player, on: :create
  validate :valid_number_of_entries

  # An interface to return an array of the entries' content attributes.
  def words
    entries.map(&:content)
  end

  private

  def unique_to_round_and_player
    return unless List.where(player:, round:).any?

    errors.add(:player, "Already submitted a list for this round")
  end

  def valid_number_of_entries
    return unless entries.count > round.rule.max_entries_per_list

    errors.add(:entries, "Too many entries according to the round's rule")
  end
end
