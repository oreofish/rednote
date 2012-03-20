class AddDefaultToStatusFromAts < ActiveRecord::Migration
    def change
        change_column_default :ats, :status, 1
    end
end
