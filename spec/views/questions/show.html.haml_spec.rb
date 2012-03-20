require 'spec_helper'

describe "questions/show" do
  before(:each) do
    @question = assign(:question, stub_model(Question,
      :user_id => 1,
      :content => "Content",
      :attachment => "Attachment",
      :done => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Content/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Attachment/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
  end
end
