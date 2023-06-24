class AddColorToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :users, :string
    add_column :users, :color, :string

    User.all.each { |user| user.pick_color; user.save }
  end
end
