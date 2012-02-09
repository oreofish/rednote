require 'spec_helper'

describe "notes/index.html.erb" do
  before(:each) do
    assign(:notes, [
      stub_model(Note,
        :user_id => 1,
        :content => "MyText",
        :image => "Image",
        :link => "Link",
        :type => 1
      ),
      stub_model(Note,
        :user_id => 1,
        :content => "MyText",
        :image => "Image",
        :link => "Link",
        :type => 1
      )
    ])
  end

  it "renders a list of notes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Image".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Link".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
