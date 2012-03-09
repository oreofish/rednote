# == Schema Information
#
# Table name: notes
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  summary     :text
#  kind        :integer(4)      default(0)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  description :text
#  upload      :string(255)
#  message     :integer(4)      default(0)
#

class Note < ActiveRecord::Base
  acts_as_commentable
  belongs_to :user
  has_many :likes, :dependent => :destroy
  has_many :attachements, :dependent => :destroy

  validates :summary, :presence => true,
                      :length   => { :maximum => 500 }
  validates :user_id, :presence => true
  attr_accessible :summary
end
