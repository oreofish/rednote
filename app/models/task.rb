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
  has_many :tasks, :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :task
  belongs_to :user
  validates :user_id, :presence => true
  
  validates :content, :presence => true,
                      :length   => { :maximum => 255 }

  attr_accessible :parent_id, :content, :estimate, :deadline
  
  def parent
    Task.find(self.parent_id)
  end
  
  def parent_path
    if self.parent_id and self.parent_id > 0
      parent
    else
      '/tasks'
    end
  end
end
