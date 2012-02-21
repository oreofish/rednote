require 'spec_helper'

describe "likes/edit" do
  before(:each) do
    @like = assign(:like, stub_model(Like,
      :user_id => 1,
      :note_id => 1,
      :status => false
    ))
  end

  it "renders the edit like form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => likes_path(@like), :method => "post" do
      assert_select "input#like_user_id", :name => "like[user_id]"
      assert_select "input#like_note_id", :name => "like[note_id]"
      assert_select "input#like_status", :name => "like[status]"
    end
  end
end
