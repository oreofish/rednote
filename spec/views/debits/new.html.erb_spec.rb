require 'spec_helper'

describe "debits/new" do
  before(:each) do
    assign(:debit, stub_model(Debit,
      :book_id => 1,
      :user_id => 1,
      :status => 1
    ).as_new_record)
  end

  it "renders new debit form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => debits_path, :method => "post" do
      assert_select "input#debit_book_id", :name => "debit[book_id]"
      assert_select "input#debit_user_id", :name => "debit[user_id]"
      assert_select "input#debit_status", :name => "debit[status]"
    end
  end
end
