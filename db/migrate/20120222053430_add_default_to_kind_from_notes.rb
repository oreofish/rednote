class AddDefaultToKindFromNotes < ActiveRecord::Migration
  def change
    change_column_default :notes, :kind, 0
  end
end
