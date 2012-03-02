require 'spec_helper'

describe "debits/edit" do
  before(:each) do
    @debit = assign(:debit, stub_model(Debit,
      :book_id => 1,
      :user_id => 1,
      :status => 1
    ))
  end

  it "renders the edit debit form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => debits_path(@debit), :method => "post" do
      assert_select "input#debit_book_id", :name => "debit[book_id]"
      assert_select "input#debit_user_id", :name => "debit[user_id]"
      assert_select "input#debit_status", :name => "debit[status]"
    end
  end
end
