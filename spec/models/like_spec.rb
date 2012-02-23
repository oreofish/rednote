require 'spec_helper'

describe Like do
  before(:each) do
    @user = Factory(:user)
    @user2 = Factory(:user, :email => Factory.next(:email))
    @note = Factory(:note, :user => @user)
    @note2 = Factory(:note, :user => @user2)
    @attr = { 
      :status => false,
      :note_id => @note.id
    }
  end

  it "should not be created without user" do 
    like =Like.new(@attr)
    like.should_not be_valid
  end
  
    it "should create a new like with attr" do
      @user.likes.create!(@attr)
    end
    
    it "should not create without note" do 
      no_note_like = @user.likes.new(@attr.merge(:note_id => nil))
      no_note_like.should_not be_valid
    end

    it "should not create without status" do 
      no_status_like = @user.likes.new(@attr.merge(:status => nil))
      no_status_like.should_not be_valid
    end
end
