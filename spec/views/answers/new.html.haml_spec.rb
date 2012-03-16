require 'spec_helper'

describe "answers/new" do
  before(:each) do
    assign(:answer, stub_model(Answer,
      :user_id => 1,
      :question_id => 1,
      :score => 1,
      :content => "MyText",
      :attachment => "MyString",
      :done => false
    ).as_new_record)
  end

  it "renders new answer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => answers_path, :method => "post" do
      assert_select "input#answer_user_id", :name => "answer[user_id]"
      assert_select "input#answer_question_id", :name => "answer[question_id]"
      assert_select "input#answer_score", :name => "answer[score]"
      assert_select "textarea#answer_content", :name => "answer[content]"
      assert_select "input#answer_attachment", :name => "answer[attachment]"
      assert_select "input#answer_done", :name => "answer[done]"
    end
  end
end
