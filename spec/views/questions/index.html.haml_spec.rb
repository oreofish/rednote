require 'spec_helper'

describe "questions/index" do
  before(:each) do
    assign(:questions, [
      stub_model(Question,
        :user_id => 1,
        :content => "Content",
        :attachment => "Attachment",
        :done => false
      ),
      stub_model(Question,
        :user_id => 1,
        :content => "Content",
        :attachment => "Attachment",
        :done => false
      )
    ])
  end

  it "renders a list of questions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Content".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Attachment".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
