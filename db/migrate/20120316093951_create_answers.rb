class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :user_id
      t.integer :question_id, :default => 0
      t.integer :score, :default => 0
      t.text :content
      t.string :attachment
      t.boolean :done, :default => false

      t.timestamps
    end
  end
end
