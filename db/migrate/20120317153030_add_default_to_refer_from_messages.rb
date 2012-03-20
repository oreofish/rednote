class AddDefaultToReferFromMessages < ActiveRecord::Migration
    def change
        change_column_default :messages, :refer, 0
    end
end
