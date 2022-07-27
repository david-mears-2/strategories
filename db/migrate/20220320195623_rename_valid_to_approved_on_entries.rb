class RenameValidToApprovedOnEntries < ActiveRecord::Migration[7.0]
  def change
    rename_column :entries, :valid, :approved
  end
end
