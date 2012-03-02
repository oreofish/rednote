require 'spec_helper'

describe "debits/index" do
  before(:each) do
    assign(:debits, [
      stub_model(Debit,
        :book_id => 1,
        :user_id => 1,
        :status => 1
      ),
      stub_model(Debit,
        :book_id => 1,
        :user_id => 1,
        :status => 1
      )
    ])
  end

  it "renders a list of debits" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
