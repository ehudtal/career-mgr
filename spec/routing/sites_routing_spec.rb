require "rails_helper"

RSpec.describe Admin::SitesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/sites").to route_to("admin/sites#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/sites/new").to route_to("admin/sites#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/sites/1").to route_to("admin/sites#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/sites/1/edit").to route_to("admin/sites#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/sites").to route_to("admin/sites#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/sites/1").to route_to("admin/sites#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/sites/1").to route_to("admin/sites#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/sites/1").to route_to("admin/sites#destroy", :id => "1")
    end

  end
end
