class RemoveStatusFromDebits < ActiveRecord::Migration
  def up
    remove_column :debits, :status
      end

  def down
    add_column :debits, :status, :integer
  end
end
