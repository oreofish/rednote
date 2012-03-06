class Debit < ActiveRecord::Base
  validates :user_id, :presence => true, :uniqueness => true
  validates :book_id, :presence => true
  
  attr_accessible :book_id, :user_id, :status
  belongs_to :user
  belongs_to :book
end
