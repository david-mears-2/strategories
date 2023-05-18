class ChangeDefaultValueOnRevealedOnLists < ActiveRecord::Migration[7.0]
  def change
    change_column_default :lists, :revealed, false
  end
end
