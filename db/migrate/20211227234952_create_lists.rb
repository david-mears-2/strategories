class CreateLists < ActiveRecord::Migration[7.0]
  def change
    create_table :lists do |t|
      t.belongs_to :round
      t.belongs_to :user
      t.integer :points

      t.timestamps
    end
  end
end
