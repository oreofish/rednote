require 'spec_helper'

describe "questions/edit" do
  before(:each) do
    @question = assign(:question, stub_model(Question,
      :user_id => 1,
      :content => "MyString",
      :attachment => "MyString",
      :done => false
    ))
  end

  it "renders the edit question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => questions_path(@question), :method => "post" do
      assert_select "input#question_user_id", :name => "question[user_id]"
      assert_select "input#question_content", :name => "question[content]"
      assert_select "input#question_attachment", :name => "question[attachment]"
      assert_select "input#question_done", :name => "question[done]"
    end
  end
end
