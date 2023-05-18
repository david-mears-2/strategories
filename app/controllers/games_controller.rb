# rubocop:disable Metrics/ClassLength
class GamesController < ApplicationController
  before_action :require_authentication, except: %i[index]
  before_action :set_game, except: %i[index new create]

  helper_method :am_the_host?, :list

  def index
    @games = Game.order(created_at: :desc).limit(10)
  end

  def poll
    render_game
  end

  def new
    @game = Game.new
  end

  def join
    join_game
  end

  def leave
    participation = Participation.find_by(game: @game, user: current_user)

    @game.rotate_host if @game.host == current_user

    if participation.destroy
      redirect_to games_path, notice: "You left the game."
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

  def add_round
    verify_json_request

    if @game.rounds.new(rule: Rule.all.sample, category: generate_category).save
      render_game
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  def start_round
    verify_json_request

    @game.current_round.start!

    render_game
  end

  def change_round
    verify_json_request

    round = @game.current_round
    round.rule = Rule.all.sample
    round.category = generate_category
    round.save

    render_game
  end

  def add_list
    verify_json_request

    new_list = @game.current_round.lists.new(list_entries_attributes.merge(player: current_user))
    if new_list.save
      render_game
    else
      render json: new_list.errors, status: :unprocessable_entity
    end
  end

  def reveal_next_list
    next_list = @game.current_round.lists_in_order.where(revealed: false).first
    next_list.revealed = true

    if next_list.save
      render_game
    else
      render json: next_list.errors, status: :unprocessable_entity
    end
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

  def am_the_host?
    current_user == @game.host
  end

  def verify_json_request
    not_found unless request.format.json?
  end

  def render_game
    html = render_to_string("game", formats: [:html], locals: { game: @game }, layout: false)

    render json: {
      html:,
      list_length:,
      needs_to_collect_current_players_entries: needs_to_collect_current_players_entries?
    }
  end

  def generate_category
    YAML.load_file(Rails.root.join("config/categories.yml"))["categories"].sample
  end

  def needs_to_collect_current_players_entries?
    return false unless @game.current_round.present?

    @game.current_round.finished? && @game.current_round.lists.pluck(:user_id).exclude?(current_user.id)
  end

  def list
    @game.current_round.lists.find_or_initialize_by(user_id: current_user.id)
  end

  def list_entries_attributes
    { entries_attributes: entries_from_params.map { |content| { content: } } }
  end

  def entries_from_params
    JSON.parse(params.require(:entries))
  end

  def list_length
    if @game.current_round&.in_play?
      @game.current_round.rule&.max_entries_per_list&.to_i
    else
      0
    end
  end
end
