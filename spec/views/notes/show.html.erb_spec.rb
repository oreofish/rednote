require 'spec_helper'

describe "notes/show.html.erb" do
  before(:each) do
    @note = assign(:note, stub_model(Note,
      :user_id => 1,
      :content => "MyText",
      :image => "Image",
      :link => "Link",
      :type => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Image/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Link/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
