class CreateAddStatusToTasks < ActiveRecord::Migration
  def change
    create_table :add_status_to_tasks do |t|
      t.ingeter :status

      t.timestamps
    end
  end
end