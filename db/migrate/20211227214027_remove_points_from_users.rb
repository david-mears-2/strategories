class RemovePointsFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :points, :integer
  end
end
