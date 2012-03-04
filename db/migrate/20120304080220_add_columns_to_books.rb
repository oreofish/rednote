class AddColumnsToBooks < ActiveRecord::Migration
  def change
    add_column :books, :url, :string

    add_column :books, :cover, :string

  end
end
