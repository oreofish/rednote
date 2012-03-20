# == Schema Information
#
# Table name: questions
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  content    :string(255)
#  attachment :string(255)
#  done       :boolean(1)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Question < ActiveRecord::Base
  acts_as_taggable_on :tags
  belongs_to :user
  has_many :answers, :dependent => :destroy

  validates :user_id, :presence => true
  validates :content, :presence => true, :length => { :maximum => 255 }
  attr_accessible :content, :done, :tag_list
end
