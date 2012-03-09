# == Schema Information
#
# Table name: books
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  status     :string(255)     default("keep")
#  user_id    :integer(4)
#  url        :string(255)
#  cover      :string(255)
#  subtitle   :string(255)
#  author     :string(255)
#

class Book < ActiveRecord::Base
  validates :title, :presence => true
  validates :url, :presence => true
  validates :cover, :presence => true
  validates :user_id, :presence => true

  attr_accessible :title, :url, :cover, :user_id, :subtitle, :author

  has_many :debits, :dependent => :destroy 
  belongs_to :user
end
