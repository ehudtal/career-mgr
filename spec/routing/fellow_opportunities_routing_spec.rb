require "rails_helper"

RSpec.describe FellowOpportunitiesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/fellow_opportunities").to route_to("fellow_opportunities#index")
    end

    it "routes to #new" do
      expect(:get => "/fellow_opportunities/new").to route_to("fellow_opportunities#new")
    end

    it "routes to #show" do
      expect(:get => "/fellow_opportunities/1").to route_to("fellow_opportunities#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/fellow_opportunities/1/edit").to route_to("fellow_opportunities#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/fellow_opportunities").to route_to("fellow_opportunities#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/fellow_opportunities/1").to route_to("fellow_opportunities#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/fellow_opportunities/1").to route_to("fellow_opportunities#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/fellow_opportunities/1").to route_to("fellow_opportunities#destroy", :id => "1")
    end

  end
end
