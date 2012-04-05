require 'spec_helper'

describe "projects/index" do
  before(:each) do
    assign(:projects, [
      stub_model(Project,
        :user_id => 1,
        :owner_id => 2,
        :name => "Name",
        :summary => "Summary",
        :tags => "Tags"
      ),
      stub_model(Project,
        :user_id => 1,
        :owner_id => 2,
        :name => "Name",
        :summary => "Summary",
        :tags => "Tags"
      )
    ])
  end

  it "renders a list of projects" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Summary".to_s, :count => 2
    assert_select "tr>td", :text => "Tags".to_s, :count => 2
  end
end
