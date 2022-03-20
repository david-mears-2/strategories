class AddHostToGames < ActiveRecord::Migration[7.0]
  def change
    add_reference :games, :host
  end
end
