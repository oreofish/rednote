# == Schema Information
#
# Table name: tasks
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  content     :string(255)
#  estimate    :integer(4)
#  deadline    :datetime
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  assigned_to :integer(4)
#  start_at    :datetime
#  finish_at   :datetime
#

class Task < ActiveRecord::Base
  acts_as_commentable
  acts_as_taggable
  acts_as_taggable_on :projects
  
  belongs_to :task
  belongs_to :user
  validates  :user_id, :presence => true
  validates  :content, :presence => true,
                       :length   => { :maximum => 255 }

  attr_accessible :assigned_to, :content, :estimate, :deadline
  
end
