class AddUserIdToEventSeries < ActiveRecord::Migration
  def change
    add_column :event_series, :user_id, :integer
  end
end
