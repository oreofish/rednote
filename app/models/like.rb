class Like < ActiveRecord::Base
  attr_accessible :note_id, :status, :user_id
  
  belongs_to :user
  belongs_to :note
  
  validates :user_id, :presence => true
  validates :note_id, :presence => true
  validates :status,  :inclusion => { :in => [true, false] }
end
