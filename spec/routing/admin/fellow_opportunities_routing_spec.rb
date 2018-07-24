require_relative "../../rails_helper"

RSpec.describe Admin::FellowOpportunitiesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/fellow_opportunities").to route_to("admin/fellow_opportunities#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/fellow_opportunities/new").to route_to("admin/fellow_opportunities#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/fellow_opportunities/1").to route_to("admin/fellow_opportunities#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/fellow_opportunities/1/edit").to route_to("admin/fellow_opportunities#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/fellow_opportunities").to route_to("admin/fellow_opportunities#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/fellow_opportunities/1").to route_to("admin/fellow_opportunities#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/fellow_opportunities/1").to route_to("admin/fellow_opportunities#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/fellow_opportunities/1").to route_to("admin/fellow_opportunities#destroy", :id => "1")
    end

  end
end
