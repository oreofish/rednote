class AddBookToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :book, :string
  end
end
