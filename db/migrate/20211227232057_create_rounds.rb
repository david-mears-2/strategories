class CreateRounds < ActiveRecord::Migration[7.0]
  def change
    create_table :rounds do |t|
      t.belongs_to :game
      t.belongs_to :rule
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
