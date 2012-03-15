require 'spec_helper'

describe "ats/new" do
  before(:each) do
    assign(:at, stub_model(At,
      :user_id => 1,
      :at_type => "MyString",
      :at_id => 1
    ).as_new_record)
  end

  it "renders new at form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => ats_path, :method => "post" do
      assert_select "input#at_user_id", :name => "at[user_id]"
      assert_select "input#at_at_type", :name => "at[at_type]"
      assert_select "input#at_at_id", :name => "at[at_id]"
    end
  end
end
