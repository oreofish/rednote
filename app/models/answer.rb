# == Schema Information
#
# Table name: answers
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  question_id :integer(4)
#  score       :integer(4)
#  content     :text
#  done        :boolean(1)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Answer < ActiveRecord::Base
  acts_as_taggable_on :tags

  belongs_to :user
  has_many :answers, :foreign_key => 'question_id'

  validates :content, :presence => true, :length => { :maximum => 10000 }

  attr_accessible :question_id, :score, :content, :attachment, :done
end
