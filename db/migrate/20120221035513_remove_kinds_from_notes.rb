class RemoveKindsFromNotes < ActiveRecord::Migration
  def up
    remove_column :notes, :image
        remove_column :notes, :link
        remove_column :notes, :book
      end

  def down
    add_column :notes, :book, :string
    add_column :notes, :link, :string
    add_column :notes, :image, :string
  end
end
