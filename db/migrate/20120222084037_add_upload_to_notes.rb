class AddUploadToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :upload, :string

  end
end
