class RenameMessages < ActiveRecord::Migration
  def up
    rename_table :messages, :infos
  end

  def down
    rename_table :infos, :messages
  end
end
