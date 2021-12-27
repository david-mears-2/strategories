class CreateParticipations < ActiveRecord::Migration[7.0]
  def change
    create_table :participations do |t|
      t.belongs_to :game
      t.belongs_to :user
      t.integer :points, default: 0

      t.timestamps
    end
  end
end
