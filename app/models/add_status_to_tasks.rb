# == Schema Information
#
# Table name: add_status_to_tasks
#
#  id         :integer(4)      not null, primary key
#  status     :integer(4)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class AddStatusToTasks < ActiveRecord::Base
end
