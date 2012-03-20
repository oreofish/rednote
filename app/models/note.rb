# == Schema Information
#
# Table name: notes
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  summary    :text
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  message    :integer(4)      default(0)
#

class Note < ActiveRecord::Base
  acts_as_commentable
  acts_as_taggable_on :tags

  belongs_to :user
  has_many :likes, :dependent => :destroy
  has_many :attachements, :dependent => :destroy
  has_many :messages, :dependent => :destroy, :foreign_key => "message_id"

  validates :summary, :presence => true,
                      :length   => { :maximum => 500 }
  validates :user_id, :presence => true
  attr_accessible :summary, :tag_list
end
