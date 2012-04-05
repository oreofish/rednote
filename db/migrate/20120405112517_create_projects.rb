class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :user_id
      t.integer :owner_id
      t.string :name
      t.string :summary
      t.string :tags

      t.timestamps
    end
  end
end
