# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :authenticate
  before_action :set_game, only: %i[show edit update destroy]

  def index
    @games = Game.all
  end

  def show; end

  def new
    @game = Game.new
  end

  def edit; end

  def create
    @game = Game.new(game_params)

    if @game.save
      redirect_to game_url(@game), notice: "Game successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @game.update(game_params)
      redirect_to game_url(@game), notice: "Game  successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @game.destroy

    redirect_to games_url, notice: "Game successfully destroyed."
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:code)
  end
end
