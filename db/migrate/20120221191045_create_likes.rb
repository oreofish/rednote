class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :note_id
      t.boolean :status

      t.timestamps
    end
  end
end
