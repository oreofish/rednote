# == Schema Information
#
# Table name: comments
#
#  id               :integer(4)      not null, primary key
#  title            :string(50)      default("")
#  comment          :text
#  commentable_id   :integer(4)
#  commentable_type :string(255)
#  user_id          :integer(4)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

require 'spec_helper'

describe Comment do
  before(:each) do
    @user = Factory(:user)
    @attr = {
      :title => "title",
      :comment => "test content",
      :commentable_id => 1
    }
  end

  it "should not be created without user" do 
    comment = Comment.new(@attr)
    comment.should_not be_valid
  end
  
  describe "title verify" do
    it "should create a new comment with attr" do
      @user.comments.create!(@attr)
    end
    
    it "should create without title" do 
      no_title_comment = @user.comments.new(@attr.merge(:title => ""))
      no_title_comment.should be_valid
    end
    
    it "should create with long title" do 
      long_title = "a" * 30
      long_comment = @user.comments.new(@attr.merge(:title => long_title))
      long_comment.save
      long_comment.reload.title == long_title
    end
    
    it "should not create with too long title" do 
      long_title = "a" * 31
      long_comment = @user.comments.new(@attr.merge(:title => long_title))
      long_comment.should_not be_valid
    end
  end

  describe "comment verify" do
    it "should not create without comment" do 
      no_comment_comment = @user.comments.new(@attr.merge(:comment => ""))
      no_comment_comment.should_not be_valid
    end
  
    # we allow to create short comment
  
    it "should create with long comment" do 
      long_comment = "a" * 255
      long_comment = @user.comments.new(@attr.merge(:comment => long_comment))
      long_comment.save
      long_comment.reload.comment == long_comment
    end
  
    it "should not create with too long comment" do 
      long_comment = "a" * 256
      long_comment = @user.comments.new(@attr.merge(:comment => long_comment))
      long_comment.should_not be_valid
    end
  end
end
