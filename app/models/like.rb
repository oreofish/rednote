class Like < ActiveRecord::Base
  attr_accessible :note_id, :status
  
  belongs_to :user
  belongs_to :note
  
  validates :user_id, :presence => true
  validates :idea_id, :presence => true
  validates :status,  :presence => true
end
