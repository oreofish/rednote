class AddColumnToBooks < ActiveRecord::Migration
  def change
    add_column :books, :status, :string

    add_column :books, :user_id, :integer

  end
end
