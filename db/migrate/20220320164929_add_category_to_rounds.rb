class AddCategoryToRounds < ActiveRecord::Migration[7.0]
  def change
    add_column :rounds, :category, :text
  end
end
