# == Schema Information
#
# Table name: tasks
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  parent_id  :integer(4)
#  content    :string(255)
#  estimate   :integer(4)
#  deadline   :datetime
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Task < ActiveRecord::Base
  acts_as_commentable
  belongs_to :user
  validates :user_id, :presence => true
  
  validates :content, :presence => true,
                      :length   => { :maximum => 255 }

  attr_accessible :parent_id, :content, :estimate, :deadline
end
