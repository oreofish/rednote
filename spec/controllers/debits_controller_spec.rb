require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe DebitsController do

  before(:each) do
    @user = Factory(:user)
    sign_in @user
    @book = Factory(:book)
  end


  # This should return the minimal set of attributes required to create a valid
  # Debit. As you add validations to Debit, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
        :user_id => @user.id,
        :book_id => @book.id
    }
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DebitsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET new" do
      it "creates a new Debit" do
        expect {
          get :new, {:book_id => @book.id}
        }.to change(Debit, :count).by(1)
      end

      it "should not debit when you are reading a book" do
      end

  end

  describe "DELETE destroy" do
    it "destroys the requested debit" do
      debit = Debit.create! valid_attributes
      expect {
        delete :destroy, {:id => debit.to_param}
      }.to change(Debit, :count).by(-1)
    end
  end

  describe "POST unwaiting" do
      it "remove debit" do
          debit = Debit.create! valid_attributes
          expect {
          post :unwaiting, {:book_id => @book.to_param}
          }.to change(Debit, :count).by(-1)
      end
  end

end
