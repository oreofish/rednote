class FixColumnNames < ActiveRecord::Migration
  def change
    change_table :notes do |t|
      t.rename :type, :kind
    end
  end
end
