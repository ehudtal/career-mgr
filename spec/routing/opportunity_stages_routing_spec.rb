require "rails_helper"

RSpec.describe OpportunityStagesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/opportunity_stages").to route_to("opportunity_stages#index")
    end

    it "routes to #new" do
      expect(:get => "/opportunity_stages/new").to route_to("opportunity_stages#new")
    end

    it "routes to #show" do
      expect(:get => "/opportunity_stages/1").to route_to("opportunity_stages#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/opportunity_stages/1/edit").to route_to("opportunity_stages#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/opportunity_stages").to route_to("opportunity_stages#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/opportunity_stages/1").to route_to("opportunity_stages#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/opportunity_stages/1").to route_to("opportunity_stages#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/opportunity_stages/1").to route_to("opportunity_stages#destroy", :id => "1")
    end

  end
end
