require 'spec_helper'

describe "notes/edit.html.erb" do
  before(:each) do
    @note = assign(:note, stub_model(Note,
      :user_id => 1,
      :content => "MyText",
      :image => "MyString",
      :link => "MyString",
      :type => 1
    ))
  end

  it "renders the edit note form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => notes_path(@note), :method => "post" do
      assert_select "input#note_user_id", :name => "note[user_id]"
      assert_select "textarea#note_content", :name => "note[content]"
      assert_select "input#note_image", :name => "note[image]"
      assert_select "input#note_link", :name => "note[link]"
      assert_select "input#note_type", :name => "note[type]"
    end
  end
end
