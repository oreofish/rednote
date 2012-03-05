class AddDefaultToStatusFromBooks < ActiveRecord::Migration
    def change
        change_column_default :books, :status, "keep"
    end
end
