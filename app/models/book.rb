class Book < ActiveRecord::Base

  validates :title, :presence => true
  attr_accessible :title
  has_many :debits, :dependent => :destroy 

end
