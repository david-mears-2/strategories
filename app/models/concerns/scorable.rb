# This module exists to keep separate all the code that knows how to calculates scores for each rule.
module Scorable
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength
  included do
    private

    # player_words: a 1-D array of some player's words.
    # all_word_lists: a 2-D array of each player's words.
    def one_on_one(player_words, all_word_lists)
      player_words.count do |word|
        number_of_players_who_submitted_this_word(word, all_word_lists) == 2
      end
    end

    # player_words: a 1-D array of some player's words.
    # all_word_lists: a 2-D array of each player's words.
    def threeway(player_words, all_word_lists)
      score = 0

      player_words.uniq.each do |word|
        score += number_of_players_who_submitted_this_word(word, all_word_lists) - 1
      end

      score
    end

    # player_words: a 1-D array of some player's words.
    # all_word_lists: a 2-D array of each player's words.
    def forgotten_four(player_words, all_word_lists)
      player_words.count do |word|
        number_of_players_who_submitted_this_word(word, all_word_lists) == 1
      end
    end

    # player_words: a 1-D array of some player's words.
    # all_word_lists: a 2-D array of each player's words.
    def the_underdog(player_words, all_word_lists)
      return unless player_words.any?

      all_words = all_word_lists.map(&:first) # Rule dictates player can submit only one word
      player_word = player_words.first # Rule dictates player can submit only one word

      wc = word_counts(all_words)
      second_most_popular_count = wc.values.sort[-2]

      wc[player_word] == second_most_popular_count ? 1 : 0
    end

    # player_words: a 1-D array of some player's words.
    # all_word_lists: a 2-D array of each player's words.
    def herd_mentality(player_words, all_word_lists)
      return unless player_words.any?

      all_words = all_word_lists.map(&:first) # Rule dictates player can submit only one word
      player_word = player_words.first # Rule dictates player can submit only one word

      wc = word_counts(all_words)
      most_popular_count = wc.values.max

      wc[player_word] == most_popular_count ? 1 : 0
    end

    def number_of_players_who_submitted_this_word(word, all_word_lists)
      all_word_lists.count { |list| list.include?(word) }
    end

    # Returns a hash of the number of times a word occurs over all word lists.
    def word_counts(all_words)
      all_words.each_with_object(Hash.new(0)) do |word, hash|
        hash[word] += 1
      end
    end
  end
  # rubocop:enable Metrics/BlockLength
end
