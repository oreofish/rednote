class AddColumnsFromMessages < ActiveRecord::Migration
  def change
    add_column :messages, :message_id, :integer

    add_column :messages, :message_type, :string

    add_column :messages, :read, :integer

    add_column :messages, :refer, :integer

  end
end
