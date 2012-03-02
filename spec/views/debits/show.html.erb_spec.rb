require 'spec_helper'

describe "debits/show" do
  before(:each) do
    @debit = assign(:debit, stub_model(Debit,
      :book_id => 1,
      :user_id => 1,
      :status => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
