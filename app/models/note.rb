# == Schema Information
#
# Table name: notes
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  summary     :text
#  kind        :integer(4)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  description :text
#

class Note < ActiveRecord::Base
  acts_as_commentable
  validates :summary, :presence => true,
                      :length   => { :maximum => 100 }
  validates :user_id, :presence => true
  validates :kind,    :presence => true,
                      :numericality => true,
                      :inclusion    => { :in => 0..5 } # this can not work with sqlite3
  validates :description, :length   => { :maximum => 20000 }

  belongs_to :user
  attr_accessible :summary, :description, :kind, :upload, :upload_cache

  mount_uploader :upload, AttachmentUploader

  has_many :likes, :dependent => :destroy

end
