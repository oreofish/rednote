class Debit < ActiveRecord::Base
  validates :user_id, :presence => true, :uniqueness => { :scope => :book_id }
  validates :book_id, :presence => true
  
  attr_accessible :book_id, :user_id, :status
  belongs_to :user
  belongs_to :book
end
