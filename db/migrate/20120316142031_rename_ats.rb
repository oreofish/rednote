class RenameAts < ActiveRecord::Migration
  def up
    rename_table :ats, :messages
  end

  def down
    rename_table :messages, :ats
  end
end
