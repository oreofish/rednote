class CreateDebits < ActiveRecord::Migration
  def change
    create_table :debits do |t|
      t.integer :book_id
      t.integer :user_id
      t.integer :status

      t.timestamps
    end
  end
end
