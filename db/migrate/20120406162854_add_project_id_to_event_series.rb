class AddProjectIdToEventSeries < ActiveRecord::Migration
  def change
    add_column :event_series, :project_id, :integer
  end
end
