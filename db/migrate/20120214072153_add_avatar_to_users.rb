class AddAvatarToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string, :default => "/images/icons/00.jpeg"
  end
end
