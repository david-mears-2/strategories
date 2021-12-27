class CreateRules < ActiveRecord::Migration[7.0]
  def change
    create_table :rules do |t|
      t.string :name
      t.text :description
      t.integer :max_entries_per_list

      t.timestamps
    end
  end
end
