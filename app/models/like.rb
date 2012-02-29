# == Schema Information
#
# Table name: likes
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  note_id    :integer(4)
#  status     :boolean(1)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Like < ActiveRecord::Base
  attr_accessible :note_id, :status, :user_id
 
  belongs_to :user
  belongs_to :note
  
  # one person can create only a like for one note, but can create multi likes for different notes
  validates :user_id, :presence => true , :uniqueness => { :scope => :note_id }
  validates :note_id, :presence => true
  validates :status,  :inclusion => { :in => [true, false] }
end
