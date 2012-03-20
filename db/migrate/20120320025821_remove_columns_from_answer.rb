class RemoveColumnsFromAnswer < ActiveRecord::Migration
  def up
    remove_column :answers, :done
  end

  def down
    add_column :answers, :done, :boolean
  end
end
