require "spec_helper"

describe DebitsController do
  describe "routing" do

    it "routes to #index" do
      get("/debits").should route_to("debits#index")
    end

    it "routes to #new" do
      get("/debits/new").should route_to("debits#new")
    end

    it "routes to #show" do
      get("/debits/1").should route_to("debits#show", :id => "1")
    end

    it "routes to #edit" do
      get("/debits/1/edit").should route_to("debits#edit", :id => "1")
    end

    it "routes to #create" do
      post("/debits").should route_to("debits#create")
    end

    it "routes to #update" do
      put("/debits/1").should route_to("debits#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/debits/1").should route_to("debits#destroy", :id => "1")
    end

  end
end
