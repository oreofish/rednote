# == Schema Information
#
# Table name: notes
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  content    :text
#  image      :string(255)
#  link       :string(255)
#  kind       :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Note < ActiveRecord::Base
  acts_as_commentable
  validates :kind, :presence => true
  validates :user_id, :presence => true

  belongs_to :user
  attr_accessible :content, :image, :link, :kind, :book, :description,
    :image_cache

  mount_uploader :image, ImageUploader
  mount_uploader :book, BookUploader
end
