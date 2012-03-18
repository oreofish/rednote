class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.integer :parent_id
      t.string :content
      t.float  :estimate, :default => 0
      t.timestamp :deadline

      t.timestamps
    end
  end
end
