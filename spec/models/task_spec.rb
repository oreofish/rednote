# == Schema Information
#
# Table name: tasks
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  content     :string(255)
#  estimate    :integer(4)
#  deadline    :datetime
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  assigned_to :integer(4)
#  start_at    :datetime
#  finish_at   :datetime
#

require 'spec_helper'

describe Task do
  before(:each) do
    @user = Factory(:user)
    @attr = {
      :content => "test content",
      :estimate => 1
    }
  end

  it "should not be created without user" do 
    task = Task.new(@attr)
    task.should_not be_valid
  end
  
  describe "content verify" do
    it "should create a new task with attr" do
      @user.tasks.create!(@attr)
    end
    
    it "should create without content" do 
      no_content_task = @user.tasks.new(@attr.merge(:content => ""))
      no_content_task.should be_valid
    end
    
    it "should create with long content" do 
      long_content = "a" * 255
      long_task = @user.tasks.new(@attr.merge(:content => long_content))
      long_task.save
      long_task.reload.content == long_content
    end
    
    it "should not create with too long content" do 
      long_content = "a" * 256
      long_task = @user.tasks.new(@attr.merge(:content => long_content))
      long_task.should_not be_valid
    end
  end
end
