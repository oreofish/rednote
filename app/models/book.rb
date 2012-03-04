class Book < ActiveRecord::Base
  validates :title, :presence => true
  validates :url, :presence => true

  attr_accessible :title, :url, :cover

  has_many :debits, :dependent => :destroy 
end
