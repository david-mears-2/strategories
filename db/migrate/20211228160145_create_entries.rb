class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.belongs_to :list
      t.string :content
      t.boolean :valid

      t.timestamps
    end
  end
end
