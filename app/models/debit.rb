# == Schema Information
#
# Table name: debits
#
#  id         :integer(4)      not null, primary key
#  book_id    :integer(4)
#  user_id    :integer(4)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Debit < ActiveRecord::Base
  validates :user_id, :presence => true, :uniqueness => true
  validates :book_id, :presence => true
  
  attr_accessible :book_id, :user_id, :status
  belongs_to :user
  belongs_to :book
end
