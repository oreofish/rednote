class RemoveColumnsFromNotes < ActiveRecord::Migration
  def up
    remove_column :notes, :kind
        remove_column :notes, :description
        remove_column :notes, :upload
      end

  def down
    add_column :notes, :upload, :string
    add_column :notes, :description, :text
    add_column :notes, :kind, :integer
  end
end
