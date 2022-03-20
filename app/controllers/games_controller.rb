class GamesController < ApplicationController
  include ActionController::Live

  CLIENT_SHOULD_ASSUME_CONNECTION_DEAD_AND_RETRY_CONNECTING_AFTER_SECONDS = 10
  LIVE_STREAM_UPDATE_RATE_SECONDS = 1

  # before_action :require_authentication, except: %i[index]
  before_action :set_game, only: %i[show sse join start destroy]

  def index
    @games = Game.order(created_at: :desc).limit(10)
  end

  def sse
    raise "Oh no" if CLIENT_SHOULD_ASSUME_CONNECTION_DEAD_AND_RETRY_CONNECTING_AFTER_SECONDS < LIVE_STREAM_UPDATE_RATE_SECONDS

    response.headers["Content-Type"] = "text/event-stream"
    sse = SSE.new(response.stream, retry: CLIENT_SHOULD_ASSUME_CONNECTION_DEAD_AND_RETRY_CONNECTING_AFTER_SECONDS * 1000)

    @last_updated_page_at = Time.at(0).to_datetime # Arbitrarily far in the past so that we load the game record at least once
    loop do
      if significant_changes_have_occurred_since_last_page_update?
        html = render_to_string("game", formats: [:html], locals: {game: @game}, layout: false)
        sse.write({ html: html})
        @last_updated_page_at = @game.updated_at
      else
        sse.write({ comment: "This is just a message to keep the connection alive." })
      end

      sleep(LIVE_STREAM_UPDATE_RATE_SECONDS)
    end
  ensure
    sse.close
  end

  def new
    @game = Game.new
  end

  def join
    participation = Participation.find_or_initialize_by(game: @game, user: current_user)

    if participation.save
      redirect_to game_path(@game)
    else
      redirect_to games_path, alert: "Couldn't join game", status: :unprocessable_entity
    end
  end

  def start
    @game.in_play!

    redirect_to game_path(@game), notice: "Started!"
  end

  def create
    @game = Game.new(game_params)

    if @game.save
      redirect_to game_path(@game), notice: "Game successfully created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @game.destroy

    redirect_to games_path, notice: "Game successfully destroyed."
  end

  private

  def significant_changes_have_occurred_since_last_page_update?
    @game.updated_at > @last_updated_page_at
    # relies on touch having been called on the game record
  end

  def set_game
    @game = Game.find(game_id)
  end

  def game_id
    params[:id] || params[:game_id]
  end

  def game_params
    params.require(:game).permit(:code)
  end
end
