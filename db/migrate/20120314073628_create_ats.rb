class CreateAts < ActiveRecord::Migration
  def change
    create_table :ats do |t|
      t.integer :user_id
      t.string :at_type
      t.integer :at_id

      t.timestamps
    end
  end
end
