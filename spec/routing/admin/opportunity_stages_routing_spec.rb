require_relative "../../rails_helper"

RSpec.describe Admin::OpportunityStagesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/opportunity_stages").to route_to("admin/opportunity_stages#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/opportunity_stages/new").to route_to("admin/opportunity_stages#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/opportunity_stages/1").to route_to("admin/opportunity_stages#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/opportunity_stages/1/edit").to route_to("admin/opportunity_stages#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/opportunity_stages").to route_to("admin/opportunity_stages#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/opportunity_stages/1").to route_to("admin/opportunity_stages#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/opportunity_stages/1").to route_to("admin/opportunity_stages#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/opportunity_stages/1").to route_to("admin/opportunity_stages#destroy", :id => "1")
    end

  end
end
