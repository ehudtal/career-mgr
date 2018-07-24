require_relative "../../rails_helper"

RSpec.describe Admin::CohortsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/cohorts").to route_to("admin/cohorts#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/cohorts/new").to route_to("admin/cohorts#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/cohorts/1").to route_to("admin/cohorts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/cohorts/1/edit").to route_to("admin/cohorts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/cohorts").to route_to("admin/cohorts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/cohorts/1").to route_to("admin/cohorts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/cohorts/1").to route_to("admin/cohorts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/cohorts/1").to route_to("admin/cohorts#destroy", :id => "1")
    end

  end
end
