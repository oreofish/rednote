# == Schema Information
#
# Table name: tasks
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  content     :string(255)
#  estimate    :float
#  deadline    :datetime
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  assigned_to :integer(4)
#  start_at    :datetime
#  finish_at   :datetime
#  status      :integer(4)      default(0)
#

class Task < ActiveRecord::Base
  acts_as_commentable
  acts_as_taggable_on :projects
  #has_event_calendar :start_at_field => 'start_at', :end_at_field => 'finish_at'
  has_event_calendar :start_at_field => 'created_at', :end_at_field => 'updated_at'
  
  belongs_to :task
  belongs_to :user
  validates  :user_id, :presence => true
  validates  :content, :presence => true,
                       :length   => { :maximum => 255 }

  attr_accessible :assigned_to, :content, :estimate, :deadline,
                  :status, :start_at, :finish_at
  
  default_scope order(:status, :updated_at)
  
  TODO = 0
  DOING = 1
  DONE = 2
  HIGHEST = 3 # reserve
  HIGH = 4 # reserve
  CANCELED = 5 # reserve
  MERGED = 6 # reserve
end
