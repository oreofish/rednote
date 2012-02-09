class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :user_id
      t.text :content
      t.string :image
      t.string :link
      t.integer :type

      t.timestamps
    end
  end
end
