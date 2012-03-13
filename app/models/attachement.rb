# == Schema Information
#
# Table name: attachements
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  note_id    :integer(4)
#  url        :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Attachement < ActiveRecord::Base
  mount_uploader :url, AttachmentUploader

  attr_accessible :url, :note_id
  
  belongs_to :note
  belongs_to :user
end
