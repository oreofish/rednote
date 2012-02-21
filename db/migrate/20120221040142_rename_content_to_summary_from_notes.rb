class RenameContentToSummaryFromNotes < ActiveRecord::Migration
  def change
    change_table :notes do |t|
      t.rename :content, :summary
    end
  end
end
