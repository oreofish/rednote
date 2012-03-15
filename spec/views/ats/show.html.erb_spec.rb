require 'spec_helper'

describe "ats/show" do
  before(:each) do
    @at = assign(:at, stub_model(At,
      :user_id => 1,
      :at_type => "At Type",
      :at_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/At Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
