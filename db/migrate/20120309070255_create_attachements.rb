class CreateAttachements < ActiveRecord::Migration
  def change
    create_table :attachements do |t|
      t.integer :user_id
      t.integer :note_id
      t.string :url

      t.timestamps
    end
  end
end
