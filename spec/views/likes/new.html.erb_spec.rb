require 'spec_helper'

describe "likes/new" do
  before(:each) do
    assign(:like, stub_model(Like,
      :user_id => 1,
      :note_id => 1,
      :status => false
    ).as_new_record)
  end

  it "renders new like form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => likes_path, :method => "post" do
      assert_select "input#like_user_id", :name => "like[user_id]"
      assert_select "input#like_note_id", :name => "like[note_id]"
      assert_select "input#like_status", :name => "like[status]"
    end
  end
end
