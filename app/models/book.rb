class Book < ActiveRecord::Base
  validates :title, :presence => true
  validates :url, :presence => true
  validates :cover, :presence => true
  validates :user_id, :presence => true

  attr_accessible :title, :url, :cover, :user_id

  has_many :debits, :dependent => :destroy 
  belongs_to :user
end
