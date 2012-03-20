class RemoveColumnsFromMessages < ActiveRecord::Migration
  def up
    remove_column :messages, :at_id
        remove_column :messages, :at_type
        remove_column :messages, :status
      end

  def down
    add_column :messages, :status, :string
    add_column :messages, :at_type, :string
    add_column :messages, :at_id, :integer
  end
end
