class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :user_id
      t.string :content
      t.string :attachment
      t.boolean :done

      t.timestamps
    end
  end
end
