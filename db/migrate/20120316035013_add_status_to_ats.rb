class AddStatusToAts < ActiveRecord::Migration
  def change
    add_column :ats, :status, :integer

  end
end
