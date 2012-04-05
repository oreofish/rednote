require 'spec_helper'

describe "projects/show" do
  before(:each) do
    @project = assign(:project, stub_model(Project,
      :user_id => 1,
      :owner_id => 2,
      :name => "Name",
      :summary => "Summary",
      :tags => "Tags"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/Name/)
    rendered.should match(/Summary/)
    rendered.should match(/Tags/)
  end
end
