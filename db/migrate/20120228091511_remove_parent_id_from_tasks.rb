class RemoveParentIdFromTasks < ActiveRecord::Migration
  def up
    remove_column :tasks, :parent_id
      end

  def down
    add_column :tasks, :parent_id, :integer
  end
end
