class Document < ActiveRecord::Base
  attr_accessible :content, :project_id, :title
  belongs_to :project
  belongs_to :user
  acts_as_audited
  acts_as_commentable

  validates  :title, :presence => true
  validates  :project_id, :presence => true
  validates  :user_id, :presence => true


end
