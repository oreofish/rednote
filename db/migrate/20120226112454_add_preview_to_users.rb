class AddPreviewToUsers < ActiveRecord::Migration
  def change
    add_column :users, :preview, :string

  end
end
