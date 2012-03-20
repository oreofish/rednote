class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :note, :conditions => "message_type = 'at_in_note'", :foreign_key => "message_id"
  belongs_to :comment, :conditions => "message_type = 'new_comment' or message_type = 'at_in_comment'", :foreign_key => "message_id"
end
