class AddCommentupdateToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :commentupdate, :datetime

  end
end
