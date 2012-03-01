class AddColumnsToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :assigned_to, :integer
    add_column :tasks, :start_at, :datetime
    add_column :tasks, :finish_at, :datetime

  end
end
