require 'spec_helper'

describe "Comments" do
  describe "GET /comments" do
    it "redirect before login" do
      get comments_path
      response.should redirect_to(new_user_session_path)
    end
  end
end
