require 'spec_helper'

describe "projects/new" do
  before(:each) do
    assign(:project, stub_model(Project,
      :user_id => 1,
      :owner_id => 1,
      :name => "MyString",
      :summary => "MyString",
      :tags => "MyString"
    ).as_new_record)
  end

  it "renders new project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => projects_path, :method => "post" do
      assert_select "input#project_user_id", :name => "project[user_id]"
      assert_select "input#project_owner_id", :name => "project[owner_id]"
      assert_select "input#project_name", :name => "project[name]"
      assert_select "input#project_summary", :name => "project[summary]"
      assert_select "input#project_tags", :name => "project[tags]"
    end
  end
end
