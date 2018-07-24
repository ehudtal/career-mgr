require_relative "../../rails_helper"

RSpec.describe Admin::CoachesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/coaches").to route_to("admin/coaches#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/coaches/new").to route_to("admin/coaches#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/coaches/1").to route_to("admin/coaches#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/coaches/1/edit").to route_to("admin/coaches#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/coaches").to route_to("admin/coaches#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/coaches/1").to route_to("admin/coaches#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/coaches/1").to route_to("admin/coaches#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/coaches/1").to route_to("admin/coaches#destroy", :id => "1")
    end

  end
end
