require 'spec_helper'

describe "ats/index" do
  before(:each) do
    assign(:ats, [
      stub_model(At,
        :user_id => 1,
        :at_type => "At Type",
        :at_id => 1
      ),
      stub_model(At,
        :user_id => 1,
        :at_type => "At Type",
        :at_id => 1
      )
    ])
  end

  it "renders a list of ats" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "At Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
