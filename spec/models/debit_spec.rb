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

require 'spec_helper'

describe Debit do
    before(:each) do
        @user = Factory(:user)
        @book = Factory(:book)
        @book1 = Factory(:book)
        @debit = Debit.create(:user_id => @user.id, :book_id => @book.id)
    end

    it "should not be created without user" do
        debit = Debit.new(:user_id => @user.id)
        debit.should_not be_valid
    end

    it "should not be created without book" do
        debit = Debit.new(:user_id => @book.id)
        debit.should_not be_valid
    end

    it "should not be created without book" do
        debit = Debit.new(:user_id => @book.id)
        debit.should_not be_valid
    end

    it "should not create with same user" do
        @debit.save!
        @debit1 = Debit.new(:user_id => @user.id, :book_id => @book1.id)
        @debit1.should_not be_valid
    end

end
