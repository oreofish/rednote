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
  validates :summary, :presence => true
  validates :user_id, :presence => true

  belongs_to :user
  attr_accessible :summary, :description,
    :image_cache

  mount_uploader :image, ImageUploader
  mount_uploader :book, BookUploader

  has_many :likes, :dependent => :destroy
  has_many :liked_by, :through => :likes, :source => :user

  def liked_by?(user)
    likes.find_by_user_id(user)
  end
end
