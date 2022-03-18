class GameChannel < ApplicationCable::Channel
  rescue_from StandardError, with: :deliver_error_message

  # Called when the consumer has successfully
  # become a subscriber to this channel.
  def subscribed
    # stream_from "some_channel"


    # If there is a game, start a stream, else reject the subscription.
    game = Game.find(params[:id])

    if game
      stream_for game
    else
      reject
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    # This method is used when you rebroadcast a message.
  end
  
  private

  def deliver_error_message
    # broadcast_to(....)
  end
end
