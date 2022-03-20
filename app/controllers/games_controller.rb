class GamesController < ApplicationController
  before_action :require_authentication, except: %i[index]
  before_action :set_game, only: %i[show poll join leave start destroy]

  def index
    @games = Game.order(created_at: :desc).limit(10)
  end

  def poll
    html = render_to_string("game", formats: [:html], locals: { game: @game }, layout: false)

    render json: { html: html }
  end

  def new
    @game = Game.new
  end

  def join
    join_game
  end

  def leave
    participation = Participation.find_by(game: @game, user: current_user)

    if participation.destroy
      redirect_to games_path, success: "You left the game."
    else
      redirect_to game_path(@game), alert: "Couldn't leave game", status: :unprocessable_entity
    end
  end

  def start
    @game.in_play!

    redirect_to game_path(@game), notice: "Started!"
  end

  def create
    @game = Game.new(game_params.merge(host_id: current_user.id))

    if @game.save
      join_game
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @game.destroy

    redirect_to games_path, notice: "Game successfully destroyed."
  end

  private

  def set_game
    @game = Game.find(game_id)
  end

  def game_id
    params[:id] || params[:game_id]
  end

  def game_params
    params.require(:game).permit(:code)
  end

  def join_game
    participation = Participation.find_or_initialize_by(game: @game, user: current_user)

    if participation.save
      redirect_to game_path(@game), notice: "Game successfully joined"
    else
      redirect_to games_path, alert: "Couldn't join game", status: :unprocessable_entity
    end
  end
end
