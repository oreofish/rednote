# == Schema Information
#
# Table name: comments
#
#  id               :integer(4)      not null, primary key
#  title            :string(50)      default("")
#  comment          :text
#  commentable_id   :integer(4)
#  commentable_type :string(255)
#  user_id          :integer(4)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true

  default_scope :order => 'created_at ASC'

  validates :user_id,        :presence => true
  validates :commentable_id, :presence => true
  validates :title,   :length       => { :maximum => 30 }
  validates :comment, :presence     => true,
                      :length       => { :maximum => 255 }

  attr_accessible :title, :comment, :commentable_id, :commentable_type

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user
end
