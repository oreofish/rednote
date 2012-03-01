class AddMessageToNote < ActiveRecord::Migration
  def self.up
    add_column :notes, :message, :integer, :default => 0
  end

  def self.down 
    remove_column :notes, :message
  end

end

