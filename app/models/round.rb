class Round < ApplicationRecord
  belongs_to :game
  belongs_to :rule
  has_many :lists

  enum status: %i[draft in_play finished]

  MAX_TIME = 30.seconds

  def human_readable_status
    {
      draft: "Not started",
      in_play: "In play",
      finished: "Finished"
    }[status.to_sym]
  end

  def mark_as_finished!
    # TODO: watch out for race conditions - maybe check whether the player is the host (unique)
    finished!
    game.rotate_host
  end

  def start!
    self.started_at = Time.zone.now
    in_play!
    save
  end

  def time_remaining
    return unless started_at
    return 0 if finished?

    finishes_at = started_at + MAX_TIME

    time_left = finishes_at - Time.zone.now

    mark_as_finished! if time_left.negative?

    [time_left.to_i, 0].max
  end

  def lists_in_order
    lists.order(:created_at)
  end
end
