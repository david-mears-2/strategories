class AddRevealedToLists < ActiveRecord::Migration[7.0]
  def change
    add_column :lists, :revealed, :boolean
  end
end
