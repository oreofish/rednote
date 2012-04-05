# == Schema Information
#
# Table name: answers
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  question_id :integer(4)
#  score       :integer(4)
#  content     :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  validates :user_id, :presence => true
  validates :content, :presence => true, :length => { :maximum => 10000 }

  attr_accessible :question_id, :score, :content
end
