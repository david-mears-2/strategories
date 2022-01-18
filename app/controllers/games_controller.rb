class GamesController < ApplicationController
  before_action :require_authentication, except: %i[index]
  before_action :set_game, only: %i[show join start destroy]

  def index
    @games = Game.order(created_at: :desc).limit(10)
  end

  def show; end

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
