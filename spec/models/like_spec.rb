# == Schema Information
#
# Table name: likes
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  note_id    :integer(4)
#  status     :boolean(1)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

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
      no_note_like = @user.likes.create(@attr.merge(:note_id => nil))
      no_note_like.should_not be_valid
    end

    it "should not create without status" do 
      no_status_like = @user.likes.create(@attr.merge(:status => nil))
      no_status_like.should_not be_valid
    end
    
    it "should not create two same likes" do 
      like = @user.likes.create(@attr)
      like.save;
      like1 = @user.likes.create(@attr)
      like1.should_not be_valid
    end
    
    it "should not create multi likes for a notes" do 
      like = @user.likes.create(@attr)
      like.save;
      like1 = @user2.likes.create(@attr)
      like1.should be_valid
    end

    it "should not create multi likes for a user" do 
      like = @user.likes.create(@attr)
      like.save;
      like1 = @user.likes.create(@attr.merge(:note_id => @note2.id))
      like1.should be_valid
    end
end
