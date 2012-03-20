class AddDefaultToReadFromMessages < ActiveRecord::Migration
    def change
        change_column_default :messages, :read, 1
    end
end
