# == Schema Information
#
# Table name: notes
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  summary    :text
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  message    :integer(4)      default(0)
#

require 'spec_helper'

describe Note do
  before(:each) do
    @user = Factory(:user)
    @attr = {
      :summary => "summary",
      :kind => 1,
      :description => "test description"
    }
  end

  it "should not be created without user" do 
    note = Note.new(@attr)
    note.should_not be_valid
  end
  
  describe "Summary" do
    it "should create a new note with attr" do
      @user.notes.create!(@attr)
    end
    
    it "should not create without summary" do 
      no_summary_note = @user.notes.new(@attr.merge(:summary => ""))
      no_summary_note.should_not be_valid
    end
    
    it "should create with long summary" do 
      long_summary = "a" * 100
      long_note = @user.notes.new(@attr.merge(:summary => long_summary))
      long_note.save
      long_note.reload.summary == long_summary
    end
    
    it "should not create with too long summary" do 
      long_summary = "a" * 101
      long_note = @user.notes.new(@attr.merge(:summary => long_summary))
      long_note.should_not be_valid
    end
  
  end

  describe "description verify" do
    it "should create without description" do 
      no_description_note = @user.notes.new(@attr.merge(:description => ""))
      no_description_note.should be_valid
    end
  
    # we allow to create short note
  
    it "should create with long description" do 
      long_description = "a" * 20000
      long_note = @user.notes.new(@attr.merge(:description => long_description))
      long_note.save
      long_note.reload.description == long_description
    end
  
    it "should not create with too long description" do 
      long_description = "a" * 20001
      long_note = @user.notes.new(@attr.merge(:description => long_description))
      long_note.should_not be_valid
    end
  end
  
  describe "associations" do
    before(:each) do
      @note = @user.notes.create(@attr)
    end
    
    describe "user associations" do
      it "should have a user attribute" do
        @note.should respond_to(:user)
      end
    end
    
  end
end
