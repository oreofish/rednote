class AddAssignedToToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :assigned_to, :integer

  end
end
