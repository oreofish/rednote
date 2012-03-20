require 'spec_helper'

describe "questions/new" do
  before(:each) do
    assign(:question, stub_model(Question,
      :user_id => 1,
      :content => "MyString",
      :attachment => "MyString",
      :done => false
    ).as_new_record)
  end

  it "renders new question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => questions_path, :method => "post" do
      assert_select "input#question_user_id", :name => "question[user_id]"
      assert_select "input#question_content", :name => "question[content]"
      assert_select "input#question_attachment", :name => "question[attachment]"
      assert_select "input#question_done", :name => "question[done]"
    end
  end
end
