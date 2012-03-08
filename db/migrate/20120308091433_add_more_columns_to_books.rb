class AddMoreColumnsToBooks < ActiveRecord::Migration
  def change
    add_column :books, :subtitle, :string

    add_column :books, :author, :string

  end
end
