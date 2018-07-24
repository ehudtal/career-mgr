require_relative "../../rails_helper"

RSpec.describe Admin::EmployersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/employers").to route_to("admin/employers#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/employers/new").to route_to("admin/employers#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/employers/1").to route_to("admin/employers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/employers/1/edit").to route_to("admin/employers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/employers").to route_to("admin/employers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/employers/1").to route_to("admin/employers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/employers/1").to route_to("admin/employers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/employers/1").to route_to("admin/employers#destroy", :id => "1")
    end

  end
end
