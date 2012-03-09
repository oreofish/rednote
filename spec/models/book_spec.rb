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

require 'spec_helper'

describe Book do
    before(:each) do
        @user = Factory(:user)
        @book = Factory(:book)
        @attr = {
            :title => "title",
            :url => "url",
            :cover => "cover"
        }
    end

    it "should not be created without user" do
        debit = Book.new(@attr)
        debit.should_not be_valid
    end

    it "should create a new book with attr" do
        @user.books.create!(@attr)
    end

    it "should not create without title" do
        no_title_book = @user.books.new(@attr.merge(:title => ""))
        no_title_book.should_not be_valid
    end

    it "should not create without url" do
        no_title_book = @user.books.new(@attr.merge(:url => ""))
        no_title_book.should_not be_valid
    end

    it "should not create without cover" do
        no_title_book = @user.books.new(@attr.merge(:cover => ""))
        no_title_book.should_not be_valid
    end

    it "should have a debit attribute" do
        @book.debits.should be_empty
    end

end
